# Inicia o servidor Laravel em background e salva o PID em server.pid
# Uso: PowerShell -ExecutionPolicy Bypass -File .\start-server.ps1

$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectDir

$pidFile = Join-Path $projectDir 'server.pid'
$logFile = Join-Path $projectDir 'server.log'
$host = '127.0.0.1'
$port = 8001

if (Test-Path $pidFile) {
    try {
        $existingPid = Get-Content $pidFile | ForEach-Object { [int]$_ }
        if (Get-Process -Id $existingPid -ErrorAction SilentlyContinue) {
            Write-Host "Já existe um servidor rodando com PID $existingPid. Pare-o antes de iniciar outro." -ForegroundColor Yellow
            exit 1
        } else {
            Write-Host "Arquivo PID encontrado mas processo não existe. Removendo PID antigo." -ForegroundColor Yellow
            Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
        }
    } catch {
        Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
    }
}

# Start-Process vai iniciar o php artisan serve em um processo separado
$arguments = @('artisan','serve','--host=' + $host,'--port=' + $port)
$proc = Start-Process -FilePath 'php' -ArgumentList $arguments -WorkingDirectory $projectDir -PassThru

if ($proc -and $proc.Id) {
    $proc.Id | Out-File -FilePath $pidFile -Encoding ascii
    Write-Host "Servidor iniciado em background. PID: $($proc.Id)" -ForegroundColor Green
    Write-Host "Log: $logFile (se desejar, abra em outro terminal)"
} else {
    Write-Host "Não foi possível iniciar o servidor." -ForegroundColor Red
    exit 1
}
