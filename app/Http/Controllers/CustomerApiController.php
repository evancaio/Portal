<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CustomerApiController extends Controller
{
    /**
     * Sincroniza cliente recebido do chatbot
     * Se existir pelo phone → atualiza
     * Se não existir → cria
     */
    public function sync(Request $request): JsonResponse
    {
        try {
            // Validar dados de entrada
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'phone' => 'required|string',
                'email' => 'nullable|email|max:255',
                'plan_name' => 'nullable|string|max:255',
                'status' => 'nullable|string|in:active,cancelled,trial,pending',
                'started_at' => 'nullable|date',
                'extra_data' => 'nullable|array',
            ]);

            // updateOrCreate baseado no phone
            $customer = Customer::updateOrCreate(
                ['phone' => $validated['phone']], // Chave de busca
                $validated // Dados para atualizar/criar
            );

            return response()->json([
                'success' => true,
                'message' => 'Cliente sincronizado com sucesso.',
                'customer' => $customer,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erro ao sincronizar cliente: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Deleta um cliente pelo telefone
     */
    public function delete($phone): JsonResponse
    {
        $customer = Customer::where('phone', $phone)->first();

        if (!$customer) {
            return response()->json([
                'success' => false,
                'message' => 'Cliente não encontrado.',
            ], 404);
        }

        $customer->delete();

        return response()->json([
            'success' => true,
            'message' => 'Cliente deletado com sucesso.',
        ], 200);
    }
}
