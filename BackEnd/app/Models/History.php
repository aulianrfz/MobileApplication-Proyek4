<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class History extends Model
{
    use HasFactory;

    protected $fillable = ['app_name', 'generated_at', 'status', 'user_id'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
