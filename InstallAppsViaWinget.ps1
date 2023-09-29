# winget を使用してアプリをインストールする
# インストールに使用する名前は ID
# ツールを検索する方法
# winget search <appname>

chcp 65001

function Install([string]$name) {
    $job = Start-Job -ScriptBlock {
        param($n)
        echo "$($n) のインストールを開始"
        winget install --id $n --scope machine
    } -argumentList $name

    # job の完了を待つ
    Wait-Job -job $job >$null
    Receive-Job -job $job
}

# 2023.09.21 Windows 11 22H2 22621.1702
# VSCode
Install Microsoft.VisualStudioCode
# Google Chrome
Install Google.Chrome
# Google 日本語入力
Install Google.JapaneseIME
# 7Zip
Install 7zip.7zip
## FFmpeg
Install Gyan.FFmpeg
# PowerToys
Install Microsoft.PowerToys


Pause