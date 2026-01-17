@echo off
setlocal
chcp 932

cd /d %~dp0

rem --- 管理者権限のチェックと昇格 ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 管理者権限が必要です。昇格しています...
    powershell -NoProfile -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)