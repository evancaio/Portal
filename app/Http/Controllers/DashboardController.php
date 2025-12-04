<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * Exibe a página dashboard (HTML)
     */
    public function index()
    {
        return file_get_contents(resource_path('views/dashboard.html'));
    }

    /**
     * Retorna os clientes em JSON para a dashboard
     */
    public function customers(): JsonResponse
    {
        $customers = Customer::orderBy('updated_at', 'desc')->get();
        return response()->json($customers);
    }
}
