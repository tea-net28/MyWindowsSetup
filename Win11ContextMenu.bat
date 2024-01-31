@echo off
@chcp 65001 > nul

rem 右クリック時に表示されるメニューを Windows 10 仕様のものに設定

echo "右クリック時に表示されるメニューを Windows 10 仕様のものに設定"
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f

rem Windows 11 仕様に戻る場合は以下
rem echo "右クリック時に表示されるメニューを Windows 11 仕様のものに設定"
rem reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f

pause