<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Father extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 
        'nik',
        'name',
        'address',
        'city',
        'nationality',
        'gender',
        'religion',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
