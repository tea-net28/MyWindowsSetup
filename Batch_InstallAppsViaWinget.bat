rem PowerSHell を起動するためのバッチファイル

chcp 65001
PowerShell Set-ExecutionPolicy RemoteSigned
PowerShell .\InstallAppsViaWinget.ps1

pause