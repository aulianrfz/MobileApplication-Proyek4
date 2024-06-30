<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Crypt;

class Health extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'bloodPressure', 'bloodSugar', 'heartRate'];

    // Mutators for encryption and decryption
    public function setBloodPressureAttribute($value)
    {
        $this->attributes['bloodPressure'] = Crypt::encryptString($value);
    }

    public function getBloodPressureAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setBloodSugarAttribute($value)
    {
        $this->attributes['bloodSugar'] = Crypt::encryptString($value);
    }

    public function getBloodSugarAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setHeartRateAttribute($value)
    {
        $this->attributes['heartRate'] = Crypt::encryptString($value);
    }

    public function getHeartRateAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    // Relationship with User model
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
