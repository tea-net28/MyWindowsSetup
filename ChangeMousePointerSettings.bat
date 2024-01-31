@echo off
@chcp 65001 > nul

rem マウスポインターの設定を変更するバッチファイル
rem 色を黒に変更し サイズを Windows 11 設定基準の 2 に変更する

rem マウスポインターの色を黒に変更
reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /ve /t "REG_SZ" /d "Windows Black" /f

rem マウスポインターのサイズを変更
reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /v "CursorBaseSize" /t "REG_DWORD" /d "0x00000030" /f

pause