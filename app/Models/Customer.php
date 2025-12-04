<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'phone',
        'email',
        'plan_name',
        'status',
        'started_at',
        'extra_data',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'extra_data' => 'array',
    ];
}
