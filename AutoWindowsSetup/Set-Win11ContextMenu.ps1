# Windows 11 で変わったコンテキストメニューを従来のスタイルに戻すスクリプト

# 共通ライブラリの読み込み
. "$PSScriptRoot\ClassLibrary\Logger.ps1"
. "$PSScriptRoot\ClassLibrary\CommonUtil.ps1"

# レジストリパスの定義
$CLSIDPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

[Logger]::Info("コンテキストメニューを従来のスタイルに戻しています...")

# レジストリキーの作成
If (-Not (Test-Path $CLSIDPath)) {
    New-Item -Path $CLSIDPath -Force | Out-Null
}

# デフォルト値を空に設定
Set-ItemProperty -Path $CLSIDPath -Name "(default)" -Value ""

# Windows 11 の新しいコンテキストメニューにする場合は以下
# Remove-Item -Path $CLSIDPath -Recurse -Force


# --- 設定反映 (エクスプローラーの再起動) ---
[CommonUtil]::RestartExplorer()

[Logger]::Success("◆◆◆ コンテキストメニューの設定変更が完了しました ◆◆◆")