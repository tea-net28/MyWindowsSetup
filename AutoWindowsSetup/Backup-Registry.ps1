#Requires -RunAsAdministrator

$backupPath = "$env:SystemDrive\RegBackup"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = "$backupPath\Backup_$timestamp"

if (-not (Test-Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
}

New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null

# レジストリハイブをエクスポート
$hives = @("HKLM\SYSTEM", "HKLM\SOFTWARE", "HKLM\SAM", "HKLM\SECURITY", "HKCU")

foreach ($hive in $hives) {
    $fileName = $hive -replace "\\", "_"
    $exportPath = "$backupFolder\$fileName.reg"
    reg export $hive $exportPath /y 2>&1 | Out-Null
}

# 古いバックアップを削除（30日以上前）
Get-ChildItem -Path $backupPath -Directory | Where-Object {
    $_.Name -match "Backup_" -and $_.CreationTime -lt (Get-Date).AddDays(-30)
} | Remove-Item -Recurse -Force

Write-Output "Registry backup completed: $backupFolder"
