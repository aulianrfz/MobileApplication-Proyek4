<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Work extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'npwp',
        'company',
        'start_year',
        'end_year',
        'position',
        'address',
        'city',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
