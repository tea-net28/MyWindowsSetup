@echo off
@chcp 65001 > nul

rem Windows Update を適用後 自動的に再起動されるのをOFFにする
rem アプリを起動している状態で放置したときに勝手に再起動されるのを防止

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t "REG_DWORD" /d "0x00000001" /f

pause