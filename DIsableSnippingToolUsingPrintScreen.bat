@echo off
@chcp 65001 > nul

rem PtintScreen キーを押下すると Snipping Tool が起動する設定を無効にする
rem Windows 11 Build 22624.1546 (KB5025310) からデフォルトで ON になっている
rem FF14 でスクリーンショットを撮るときに起動するため作成

reg add "HKEY_CURRENT_USER\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t "REG_DWORD" /d "0x00000000" /f

rem ON にする場合は以下
rem reg add "HKEY_CURRENT_USER\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t "REG_DWORD" /d "0x00000001"

pause