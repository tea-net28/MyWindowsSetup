# Windows 11 で変わったコンテキストメニューを従来のスタイルに戻すスクリプト

# レジストリパスの定義
$CLSIDPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

Write-Host "コンテキストメニューを従来のスタイルに戻しています..." -ForegroundColor Cyan

# レジストリキーの作成
If (-Not (Test-Path $CLSIDPath)) {
    New-Item -Path $CLSIDPath -Force | Out-Null
}

# デフォルト値を空に設定
Set-ItemProperty -Path $CLSIDPath -Name "(default)" -Value ""

# Windows 11 の新しいコンテキストメニューにする場合は以下
# Remove-Item -Path $CLSIDPath -Recurse -Force


# --- 設定反映 (エクスプローラーの再起動) ---
Write-Host "設定を反映するためにエクスプローラーを再起動します..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force

Start-Sleep -Seconds 2
Write-Host "完了しました。" -ForegroundColor Green