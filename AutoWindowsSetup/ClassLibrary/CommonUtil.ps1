<#
.SYNOPSIS
    PowerShell スクリプトで共通使用する関数ライブラリ

.DESCRIPTION
    管理者権限チェック、エクスプローラー再起動、レジストリ操作など、
    複数のスクリプトで共通使用する関数を提供します。

.NOTES
    ファイル名: CommonUtil.ps1
    作成日: 2026-02-07
    依存: Logger.ps1
    
    使用方法: 
        . "$PSScriptRoot\ClassLibrary\Logger.ps1"
        . "$PSScriptRoot\ClassLibrary\CommonUtil.ps1"

    クラスベース呼び出し例:
        [CommonUtil]::IsAdmin()
        [CommonUtil]::RestartExplorer()
        [CommonUtil]::SetRegistryValue($path, $name, $value, "DWord")
        [CommonUtil]::Confirm("実行しますか?")
#>

# Logger.ps1が読み込まれていることが前提

# =====================================================================
# 共通ユーティリティクラス
# =====================================================================

class CommonUtil {
    # -----------------------------------------------------------------
    # システムユーティリティメソッド
    # -----------------------------------------------------------------

    static [bool] IsAdmin() {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

    static [void] RequireAdmin() {
        if (-not [CommonUtil]::IsAdmin()) {
            [Logger]::Error("このスクリプトは管理者権限で実行する必要があります")
            throw "管理者権限が必要です"
        }
    }

    static [void] RestartExplorer() {
        [CommonUtil]::RestartExplorer(2, $true)
    }

    static [void] RestartExplorer([int]$WaitSeconds) {
        [CommonUtil]::RestartExplorer($WaitSeconds, $true)
    }

    static [void] RestartExplorer([int]$WaitSeconds, [bool]$ShowMessage) {
        if ($ShowMessage) {
            [Logger]::Warning("設定を反映するためにエクスプローラーを再起動します...")
        }

        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds $WaitSeconds

        if ($ShowMessage) {
            [Logger]::Success("エクスプローラーの再起動が完了しました")
        }
    }

    static [bool] Confirm([string]$Message) {
        return [CommonUtil]::Confirm($Message, $true)
    }

    static [bool] Confirm([string]$Message, [bool]$DefaultYes) {
        $prompt = if ($DefaultYes) { "(Y/n)" } else { "(y/N)" }
        Write-Host "$Message $prompt " -NoNewline -ForegroundColor Cyan

        $response = Read-Host

        if ([string]::IsNullOrWhiteSpace($response)) {
            return $DefaultYes
        }

        return ($response -match '^[Yy](es)?$')
    }

    # -----------------------------------------------------------------
    # レジストリユーティリティメソッド
    # -----------------------------------------------------------------

    static [bool] EnsureRegistryPath([string]$Path) {
        return [CommonUtil]::EnsureRegistryPath($Path, $false)
    }

    static [bool] EnsureRegistryPath([string]$Path, [bool]$ShowMessage) {
        if (-not (Test-Path $Path)) {
            if ($ShowMessage) {
                [Logger]::Info("レジストリパスを作成します: $Path")
            }
            New-Item -Path $Path -Force | Out-Null
            return $true
        }
        return $false
    }

    static [bool] SetRegistryValue([string]$Path, [string]$Name, $Value, [string]$Type) {
        return [CommonUtil]::SetRegistryValue($Path, $Name, $Value, $Type, $false)
    }

    static [bool] SetRegistryValue([string]$Path, [string]$Name, $Value, [string]$Type, [bool]$ShowMessage) {
        try {
            [CommonUtil]::EnsureRegistryPath($Path, $false)

            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force

            if ($ShowMessage) {
                [Logger]::Success("レジストリ値を設定しました: $Path\$Name = $Value")
            }

            return $true
        }
        catch {
            [Logger]::Error("レジストリ値の設定に失敗しました: $Path\$Name - $_")
            return $false
        }
    }

    static [object] GetRegistryValue([string]$Path, [string]$Name) {
        return [CommonUtil]::GetRegistryValue($Path, $Name, $null)
    }

    static [object] GetRegistryValue([string]$Path, [string]$Name, $DefaultValue) {
        try {
            if (Test-Path $Path) {
                $value = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
                return $value.$Name
            }
            return $DefaultValue
        }
        catch {
            return $DefaultValue
        }
    }
}