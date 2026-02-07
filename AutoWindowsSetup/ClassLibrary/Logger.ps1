# =====================================================================
# ログ出力関数
# =====================================================================

<#
.SYNOPSIS
    色付きでログメッセージを出力します

.DESCRIPTION
    タイムスタンプ付きで、指定した種類に応じた色でメッセージを出力します

.PARAMETER Message
    出力するメッセージ

.PARAMETER Type
    メッセージの種類（Info, Success, Error, Warning）

.EXAMPLE
    [Logger]::Info("処理を開始します")
    [Logger]::Success("完了しました")
    [Logger]::Error("エラーが発生しました")
    [Logger]::Warning("警告メッセージ")
#>
class Logger {
    static [void] Write([string]$Message, [string]$Type) {
        [Logger]::Write($Message, $Type, $true)
    }

    static [void] Write([string]$Message, [string]$Type, [bool]$ShowTimestamp) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $color = switch ($Type) {
            "Success" { "Green" }
            "Error" { "Red" }
            "Warning" { "Yellow" }
            default { "White" }
        }

        $prefix = if ($ShowTimestamp) { "[$timestamp] " } else { "" }
        Write-Host "$prefix$Message" -ForegroundColor $color
    }

    static [void] Info([string]$Message) {
        [Logger]::Write($Message, "Info")
    }

    static [void] Success([string]$Message) {
        [Logger]::Write($Message, "Success")
    }

    static [void] Error([string]$Message) {
        [Logger]::Write($Message, "Error")
    }

    static [void] Warning([string]$Message) {
        [Logger]::Write($Message, "Warning")
    }
}