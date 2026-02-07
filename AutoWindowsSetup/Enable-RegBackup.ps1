#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows レジストリの自動バックアップを有効化するスクリプト

.DESCRIPTION
    Windows 10 バージョン 1803 以降では、レジストリの自動バックアップがデフォルトで無効になっています。
    このスクリプトは、タスクスケジューラのRegIdleBackupタスクを有効化し、
    定期的なレジストリバックアップを実行できるようにします。

.NOTES
    ファイル名: Enable-RegBackup.ps1
    作成者: 
    作成日: 2026-02-07
    要件: 管理者権限が必要
#>

# 共通ライブラリの読み込み
. "$PSScriptRoot\ClassLibrary\Logger.ps1"
. "$PSScriptRoot\ClassLibrary\CommonUtil.ps1"

# エラーハンドリング
$ErrorActionPreference = "Stop"

# メイン処理
try {
    [Logger]::Info("レジストリ自動バックアップの有効化を開始します...")
    [Logger]::Info("")

    # 管理者権限チェック
    if (-not [CommonUtil]::IsAdmin()) {
        [Logger]::Error("このスクリプトは管理者権限で実行する必要があります。")
        [Logger]::Error("PowerShellを管理者として実行してください。")
        exit 1
    }

    # レジストリバックアップディレクトリの確認
    $regBackupPath = "$env:SystemRoot\System32\config\RegBack"
    if (Test-Path $regBackupPath) {
        [Logger]::Info("レジストリバックアップディレクトリ: $regBackupPath")
    } else {
        [Logger]::Warning("レジストリバックアップディレクトリが見つかりません。")
    }

    # レジストリ設定: 自動バックアップを有効化
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager"
    $regName = "EnablePeriodicBackup"
    $regValue = 1

    [Logger]::Info("レジストリ設定を変更します...")
    
    if (-not (Test-Path $regPath)) {
        [Logger]::Info("レジストリパスが存在しないため作成します: $regPath")
        New-Item -Path $regPath -Force | Out-Null
    }

    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord -Force
    [Logger]::Success("レジストリ設定を有効化しました: $regPath\$regName = $regValue")

    # タスクスケジューラのRegIdleBackupタスクを有効化
    [Logger]::Info("")
    [Logger]::Info("タスクスケジューラのRegIdleBackupタスクを確認します...")
    
    $taskName = "RegIdleBackup"
    $taskPath = "\Microsoft\Windows\Registry\"
    
    try {
        $task = Get-ScheduledTask -TaskName $taskName -TaskPath $taskPath -ErrorAction SilentlyContinue
        
        if ($task) {
            if ($task.State -eq "Disabled") {
                Enable-ScheduledTask -TaskName $taskName -TaskPath $taskPath | Out-Null
                [Logger]::Success("タスク '$taskName' を有効化しました。")
            } elseif ($task.State -eq "Ready") {
                [Logger]::Info("タスク '$taskName' は既に有効です。")
            } else {
                [Logger]::Info("タスク '$taskName' の状態: $($task.State)")
            }
            
            # タスク情報を表示
            [Logger]::Info("")
            [Logger]::Info("タスク情報:")
            [Logger]::Info("  タスク名: $taskName")
            [Logger]::Info("  状態: $($task.State)")
            [Logger]::Info("  最終実行: $($task.LastRunTime)")
            [Logger]::Info("  次回実行: $($task.NextRunTime)")
            
        } else {
            [Logger]::Warning("タスク '$taskName' が見つかりません。")
            [Logger]::Warning("このタスクは Windows のバージョンやエディションによっては存在しない場合があります。")
        }
    } catch {
        [Logger]::Warning("タスクの確認中にエラーが発生しました: $_")
    }

    # 手動でバックアップタスクを作成（オプション）
    [Logger]::Info("")
    if ([CommonUtil]::Confirm("カスタムレジストリバックアップタスクを作成しますか?")) {
        $customTaskName = "CustomRegistryBackup"
        $backupScriptPath = "$PSScriptRoot\Backup-Registry.ps1"
        
        # バックアップスクリプトを作成
        $backupScript = @'
#Requires -RunAsAdministrator

$backupPath = "$env:SystemDrive\RegBackup"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = "$backupPath\Backup_$timestamp"

if (-not (Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
}

New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null

# レジストリハイブをエクスポート
$hives = @("HKLM\SYSTEM", "HKLM\SOFTWARE", "HKLM\SAM", "HKLM\SECURITY", "HKCU")

foreach ($hive in $hives) {
    $fileName = $hive -replace "\\", "_"
    $exportPath = "$backupFolder\$fileName.reg"
    reg export $hive $exportPath /y 2>&1 | Out-Null
}

# 古いバックアップを削除（30日以上前）
Get-ChildItem -Path $backupPath -Directory | Where-Object {
    $_.Name -match "Backup_" -and $_.CreationTime -lt (Get-Date).AddDays(-30)
} | Remove-Item -Recurse -Force

Write-Output "Registry backup completed: $backupFolder"
'@
        
        Set-Content -Path $backupScriptPath -Value $backupScript -Encoding UTF8
        [Logger]::Success("バックアップスクリプトを作成しました: $backupScriptPath")
        
        # タスクスケジューラのアクション
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
            -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$backupScriptPath`""
        
        # トリガー: 毎日午前2時
        $trigger = New-ScheduledTaskTrigger -Daily -At 2:00AM
        
        # プリンシパル: SYSTEM アカウントで実行
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        
        # タスク設定
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
            -StartWhenAvailable -RunOnlyIfNetworkAvailable:$false
        
        # タスクを登録
        Register-ScheduledTask -TaskName $customTaskName -Action $action -Trigger $trigger `
            -Principal $principal -Settings $settings -Description "毎日レジストリをバックアップします" -Force | Out-Null
        
        [Logger]::Success("カスタムタスク '$customTaskName' を作成しました。")
        [Logger]::Info("実行スケジュール: 毎日午前2時")
    }

    [Logger]::Info("")
    [Logger]::Success("レジストリ自動バックアップの有効化が完了しました。")
    [Logger]::Info("")
    [Logger]::Warning("注意事項:")
    [Logger]::Info("- レジストリバックアップは $regBackupPath に保存されます")
    [Logger]::Info("- バックアップは定期的に自動実行されます")
    [Logger]::Info("- システムがアイドル状態の時にバックアップが実行されます")

} catch {
    [Logger]::Error("エラーが発生しました: $_")
    [Logger]::Error($_.ScriptStackTrace)
    exit 1
}

# 終了メッセージ
[Logger]::Info("")
[Logger]::Success("◆◆◆ レジストリ自動バックアップの有効化処理が完了しました ◆◆◆")
