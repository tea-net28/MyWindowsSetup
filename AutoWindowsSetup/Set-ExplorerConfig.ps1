<#
.SYNOPSIS
    Windowsエクスプローラーの推奨設定を適用するスクリプト
.DESCRIPTION
    拡張子の表示、隠しファイルの表示、PCから開く設定などをレジストリ経由で変更します。
    設定後にexplorer.exeを再起動します。
#>

# 共通ライブラリの読み込み
. "$PSScriptRoot\ClassLibrary\Logger.ps1"
. "$PSScriptRoot\ClassLibrary\CommonUtil.ps1"

# レジストリパスの定義
$ExplorerPath  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$AdvancedPath  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

[Logger]::Info("===== フォルダーオプションの設定を変更しています... =====")

# === 全体タブ ===
# 開いたときの最初のページを PC にする
# 1: PC, 2: クイックアクセス/ホーム
Set-ItemProperty -Path $AdvancedPath -Name "LaunchTo" -Value 1

# 最近使用したファイルを表示する
# 0:OFF, 1:ON
Set-ItemProperty -Path $ExplorerPath -Name "ShowRecent" -Value 1

# 使用頻度の高いフォルダーを表示しない
# 0:OFF, 1:ON
Set-ItemProperty -Path $ExplorerPath -Name "ShowFrequent" -Value 0

# レコメンデーション セクションを表示しない
# 0:OFF, 1:ON
Set-ItemProperty -Path $ExplorerPath -Name "ShowRecommendations" -Value 0

# アカウントとクラウド プロバイダーのアクティビティに基づいてファイルを表示しない
# 0:OFF, 1:ON
Set-ItemProperty -Path $ExplorerPath -Name "ShowCloudFilesInQuickAccess" -Value 0

# === 表示タブ ===
# 隠しファイル、フォルダー、およびドライブを表示する
# 1:表示, 2:非表示
Set-ItemProperty -Path $AdvancedPath -Name "Hidden" -Value 1

# ファイルの拡張子を表示する
# 1:表示, 0:非表示
Set-ItemProperty -Path $AdvancedPath -Name "HideFileExt" -Value 0



# --- 設定反映 (エクスプローラーの再起動) ---
[CommonUtil]::RestartExplorer()

Start-Sleep -Seconds 2
[Logger]::Success("===== エクスプローラー設定の適用処理が完了しました =====")