# Windows のシェルフォルダーの場所を変更するスクリプト

# 共通ライブラリの読み込み
. "$PSScriptRoot\ClassLibrary\Logger.ps1"
. "$PSScriptRoot\ClassLibrary\CommonUtil.ps1"

# 新しいフォルダーのパスの共通部分
$FolderPathPrefix = "E:\_WindowsFolder"
# もとの場所に戻す場合は以下を使用
# $FolderPathPrefix = "%USERPROFILE%"

# レジストリパス
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

[Logger]::Info("個人用フォルダーの場所を変更します...")

# デスクトップ
New-ItemProperty -Path $RegPath -Name "Desktop" -Value "$FolderPathPrefix\Desktop" -PropertyType "ExpandString" -Force | Out-Null
# ドキュメント
New-ItemProperty -Path $RegPath -Name "Personal" -Value "$FolderPathPrefix\Documents" -PropertyType "ExpandString" -Force | Out-Null
# ピクチャ
New-ItemProperty -Path $RegPath -Name "My Pictures" -Value "$FolderPathPrefix\Pictures" -PropertyType "ExpandString" -Force | Out-Null
# ミュージック
New-ItemProperty -Path $RegPath -Name "My Music" -Value "$FolderPathPrefix\Music" -PropertyType "ExpandString" -Force | Out-Null
# ビデオ
New-ItemProperty -Path $RegPath -Name "My Video" -Value "$FolderPathPrefix\Videos" -PropertyType "ExpandString" -Force | Out-Null
# ダウンロード
New-ItemProperty -Path $RegPath -Name "{374DE290-123F-4565-9164-39C4925E467B}" -Value "$FolderPathPrefix\Downloads" -PropertyType "ExpandString" -Force | Out-Null
# お気に入り
New-ItemProperty -Path $RegPath -Name "Favorites" -Value "$FolderPathPrefix\Favorites" -PropertyType "ExpandString" -Force | Out-Null

# --- 設定反映 (エクスプローラーの再起動) ---
[CommonUtil]::RestartExplorer()

[Logger]::Success("◆◆◆ 個人用フォルダーの場所変更が完了しました ◆◆◆")