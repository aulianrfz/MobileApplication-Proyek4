<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Crypt;

class SocialMedia extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 
        'facebook',
        'instagram',
        'linkedIn'
    ];

    public function setFacebookAttribute($value)
    {
        $this->attributes['facebook'] = Crypt::encryptString($value);
    }

    public function getFacebookAttribute($value)
    {
        return Crypt::decryptString($value);
    }
    public function setInstagramAttribute($value)
    {
        $this->attributes['instagram'] = Crypt::encryptString($value);
    }

    public function getInstagramAttribute($value)
    {
        return Crypt::decryptString($value);
    }
    public function setLinkedInAttribute($value)
    {
        $this->attributes['linkedIn'] = Crypt::encryptString($value);
    }

    public function getLinkedInAttribute($value)
    {
        return Crypt::decryptString($value);
    }

}

