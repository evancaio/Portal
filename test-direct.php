<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);
$request = \Illuminate\Http\Request::capture();
$response = $kernel->handle($request);

// Teste: criar/atualizar cliente
$customer = \App\Models\Customer::updateOrCreate(
    ['phone' => '5511999888777'],
    [
        'name' => 'Maria Silva',
        'email' => 'maria@test.com',
        'plan_name' => 'Plano Pro',
        'status' => 'active',
        'started_at' => '2025-12-01 10:00:00',
        'extra_data' => ['origem' => 'api', 'teste' => true]
    ]
);

echo "\n✓ Cliente criado/atualizado:\n";
echo json_encode($customer->toArray(), JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";

echo "\n✓ Todos os clientes:\n";
echo json_encode(\App\Models\Customer::all()->toArray(), JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";
