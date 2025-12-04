<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CustomerApiController;
use App\Http\Controllers\DashboardController;

Route::get('/', [DashboardController::class, 'index']);
Route::get('/customers', [DashboardController::class, 'customers']);

Route::prefix('api')->withoutMiddleware(['web'])->group(function () {
    Route::post('/customers/sync', [CustomerApiController::class, 'sync']);
    Route::delete('/customers/{phone}', [CustomerApiController::class, 'delete']);
});
