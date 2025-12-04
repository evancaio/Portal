<#
deploy-plesk.ps1
Script de deploy para Plesk (Windows). Deve ser colocado na raiz do projeto (ao lado de artisan).
Use no Plesk Git "Additional deployment commands":
    powershell -ExecutionPolicy Bypass -File "deploy-plesk.ps1"
#>

Param()

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "[deploy] Iniciando deploy em: $root"

Set-Location $root

function Try-Run($cmd) {
    try {
        Write-Host "[run] $cmd"
        iex $cmd
    } catch {
        Write-Host "[error] Erro ao executar: $cmd -- $_"
    }
}

# 1) Preparar .env
if (-not (Test-Path "$root\.env")) {
    if (Test-Path "$root\.env.example") {
        Copy-Item "$root\.env.example" "$root\.env"
        Write-Host "[deploy] .env criado a partir de .env.example"
    } else {
        Write-Host "[deploy] Atenção: .env.example não encontrado. Crie um .env manualmente.";
    }
} else {
    Write-Host "[deploy] .env já existe — pulando criação."
}

# 2) Composer install (se composer estiver disponível)
if (Get-Command composer -ErrorAction SilentlyContinue) {
    Try-Run "composer install --no-dev --prefer-dist --optimize-autoloader"
} else {
    Write-Host "[deploy] Composer não encontrado no PATH. Se necessário, instale composer globalmente ou configure no Plesk. Pulando 'composer install'."
}

# 3) Gerar APP_KEY se necessário
$envText = Get-Content "$root\.env" -Raw -ErrorAction SilentlyContinue
if ($envText -and ($envText -notmatch 'APP_KEY=')) {
    Try-Run "php artisan key:generate --force"
} else {
    Write-Host "[deploy] APP_KEY já presente ou .env não disponível."
}

# 4) Criar database SQLite se não existir
$sqlitePath = Join-Path $root 'database\database.sqlite'
if (-not (Test-Path $sqlitePath)) {
    New-Item -ItemType File -Path $sqlitePath | Out-Null
    Write-Host "[deploy] database/database.sqlite criado"
} else {
    Write-Host "[deploy] database/database.sqlite já existe"
}

# 5) Ajustar permissões (IIS_IUSRS) — adapta conforme necessário
$pathsToSecure = @(
    Join-Path $root 'storage',
    Join-Path $root 'bootstrap\cache',
    Join-Path $root 'database'
)

foreach ($p in $pathsToSecure) {
    if (Test-Path $p) {
        Write-Host "[perm] Ajustando permissões em: $p"
        try {
            # Dar Modify (M) recursivo para IIS_IUSRS
            icacls "$p" /grant "IIS_IUSRS:(OI)(CI)M" /T | Out-Host
        } catch {
            Write-Host "[perm] Falha ao ajustar permissões em $p: $_"
        }
    } else {
        Write-Host "[perm] Caminho não existe: $p"
    }
}

# 6) Rodar migrations
Try-Run "php artisan migrate --force"

# 7) Limpar e cachear configurações (opcional)
Try-Run "php artisan config:cache"
Try-Run "php artisan route:cache"
Try-Run "php artisan view:cache"

Write-Host "[deploy] Deploy finalizado"
