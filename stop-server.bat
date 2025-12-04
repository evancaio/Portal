@echo off
REM Para o servidor iniciado por start-server.ps1 (ou tenta encontrar php artisan)
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop-server.ps1"
pause
