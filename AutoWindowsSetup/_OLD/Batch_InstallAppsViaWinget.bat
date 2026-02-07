rem PowerSHell を起動するためのバッチファイル

chcp 65001
PowerShell Set-ExecutionPolicy RemoteSigned
rem PowerShell .\InstallAppsViaWinget.ps1
PowerShell UninstallStoreApp.ps1

pause