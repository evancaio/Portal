<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\Request;

class CustomerApiController extends Controller
{
    public function sync(Request $request)
    {
        $data = $request->validate([
            'name'       => 'required|string',
            'phone'      => 'required|string',
            'email'      => 'nullable|email',
            'plan_name'  => 'nullable|string',
            'status'     => 'nullable|string',
            'started_at' => 'nullable|date',
            'extra_data' => 'nullable|array',
        ]);

        if (empty($data['status'])) {
            $data['status'] = 'active';
        }

        $customer = Customer::updateOrCreate(
            ['phone' => $data['phone']],
            $data
        );

        return response()->json([
            'success'  => true,
            'message'  => 'Cliente sincronizado com sucesso.',
            'customer' => $customer,
        ]);
    }
}
