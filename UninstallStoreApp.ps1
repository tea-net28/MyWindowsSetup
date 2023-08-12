# インストールされたアプリの一覧を表示
# Get-AppxPackage | Select-Object Name
chcp 65001

function Uninstall([string]$name) {
    # echo "Start unintall $name"
    # job でアンインストールを行う
    $job = Start-Job -ScriptBlock {
        param($n)
        echo "$($n) のアンインストールを開始"
        Get-AppxPackage $n | Remove-AppxPackage
    } -argumentList $name

    # job の完了を待つ
    Wait-Job -job $job >$null
    Receive-Job -job $job
}


# 2023.08.12 Windows 11 22H2 22621.2134
# Cortana
Uninstall Microsoft.549981C3F5F10
# Microsoft 365
Uninstall Microsoft.MicrosoftOfficeHub
# Clipchamp
# Uninstall Clipchamp.Clipchamp
# Microsoft Teams
Uninstall MicrosoftTeams
# Microsoft ToDo
Uninstall Microsoft.Todos
# Solitaire & Casual Games
Uninstall Microsoft.MicrosoftSolitaireCollection
# Xbox
Uninstall Microsoft.GamingApp
# クイックアシスト
Uninstall MicrosoftCorporationII.QuickAssist
# 問い合わせ
Uninstall Microsoft.GetHelp
# ニュース
Uninstall Microsoft.BingNews
# はじめに
Uninstall *Getstarted*
# ビデオエディター
# ヒント
Uninstall Microsoft.GetHelp
# フィードバック Hub
Uninstall Microsoft.WindowsFeedbackHub
# マップ
Uninstall Microsoft.WindowsMaps
# 映画 & TV
Uninstall Microsoft.ZuneVideo

# Power Automate
Uninstall Microsoft.PowerAutomateDesktop

echo "ストアアプリのアンインストールが終了しました"
Pause