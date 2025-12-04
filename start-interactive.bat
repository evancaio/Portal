@echo off
REM Inicia o servidor Laravel de forma interativa (janela permanece aberta)
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "php artisan serve --host=127.0.0.1 --port=8001"
