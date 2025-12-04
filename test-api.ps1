# Script para testar a API de sincronização de clientes

$url = "http://127.0.0.1:8000/api/customers/sync"

# Request 1: Criar novo cliente
Write-Host "=== TESTE 1: Criar novo cliente ===" -ForegroundColor Green
$body1 = @{
    name = "João da Silva"
    phone = "5521987654321"
    email = "joao@example.com"
    plan_name = "Plano Básico"
    status = "active"
    started_at = "2025-12-01 10:00:00"
    extra_data = @{
        origem = "whatsapp"
        id_bot = "456def"
    }
} | ConvertTo-Json

Write-Host "Request Body: $body1"
Write-Host ""

try {
    $response1 = Invoke-WebRequest -Uri $url -Method Post -Body $body1 -ContentType "application/json" -UseBasicParsing
    Write-Host "Response: " -ForegroundColor Cyan
    Write-Host ($response1.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3) -ForegroundColor Yellow
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}

Write-Host "`n=== TESTE 2: Atualizar cliente existente ===" -ForegroundColor Green

$body2 = @{
    name = "João da Silva Updated"
    phone = "5521987654321"
    email = "joao.novo@example.com"
    plan_name = "Plano Premium"
    status = "active"
    started_at = "2025-12-01 10:00:00"
    extra_data = @{
        origem = "whatsapp"
        id_bot = "456def"
        updated_by = "admin"
    }
} | ConvertTo-Json

Write-Host "Request Body: $body2"
Write-Host ""

try {
    $response2 = Invoke-WebRequest -Uri $url -Method Post -Body $body2 -ContentType "application/json" -UseBasicParsing
    Write-Host "Response: " -ForegroundColor Cyan
    Write-Host ($response2.Content | ConvertFrom-Json | ConvertTo-Json -Depth 3) -ForegroundColor Yellow
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}

Write-Host "`nTestes concluídos!" -ForegroundColor Green
