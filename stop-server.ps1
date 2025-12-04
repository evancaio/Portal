# Para o servidor iniciado por start-server.ps1
# Uso: PowerShell -ExecutionPolicy Bypass -File .\stop-server.ps1

$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectDir

$pidFile = Join-Path $projectDir 'server.pid'

if (Test-Path $pidFile) {
    try {
        $pid = Get-Content $pidFile | ForEach-Object { [int]$_ }
        if (Get-Process -Id $pid -ErrorAction SilentlyContinue) {
            Stop-Process -Id $pid -Force -ErrorAction Stop
            Write-Host "Servidor (PID $pid) parado." -ForegroundColor Green
        } else {
            Write-Host "Processo com PID $pid não encontrado. Limpando PID." -ForegroundColor Yellow
        }
        Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Erro ao parar o processo: $_" -ForegroundColor Red
        exit 1
    }
} else {
    # Tenta localizar processos php rodando com 'artisan' no command line (fallback)
    try {
        $artisanProcs = Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine -match 'artisan' }
        if ($artisanProcs) {
            foreach ($p in $artisanProcs) {
                try {
                    Stop-Process -Id $p.ProcessId -Force -ErrorAction Stop
                    Write-Host "Parado processo php (PID $($p.ProcessId)) identificado por 'artisan'." -ForegroundColor Green
                } catch {
                    Write-Host "Não foi possível parar PID $($p.ProcessId): $_" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "Nenhum servidor encontrado (arquivo server.pid não existe)." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Erro ao procurar processos php: $_" -ForegroundColor Red
        exit 1
    }
}
