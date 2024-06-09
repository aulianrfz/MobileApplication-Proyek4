<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Notifications\Notifiable;

class User extends Model
{
    use HasFactory, HasApiTokens, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'phone',
        'password',
        'barcode',
    ];

    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_recovery_codes',
        'two_factor_secret',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
    
    public function personal()
    {
        return $this->hasOne(Personal::class);
    }

    public function mother()
    {
        return $this->hasOne(Mother::class);
    }

    public function father()
    {
        return $this->hasOne(Father::class);
    }

    public function work()
    {
        return $this->hasOne(Work::class);
    }

    public function education()
    {
        return $this->hasOne(Education::class);
    }
}
