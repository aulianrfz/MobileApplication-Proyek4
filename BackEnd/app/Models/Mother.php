<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Crypt;

class Mother extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'nik', 'nama', 'birthday', 'address', 'city', 'nationality', 'gender', 'religion'
    ];

    // Encrypt attributes
    public function setNikAttribute($value)
    {
        $this->attributes['nik'] = Crypt::encryptString($value);
    }

    public function getNikAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setNamaAttribute($value)
    {
        $this->attributes['nama'] = Crypt::encryptString($value);
    }

    public function getNamaAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setAddressAttribute($value)
    {
        $this->attributes['address'] = Crypt::encryptString($value);
    }

    public function getAddressAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setBirthdayAttribute($value)
    {
        $this->attributes['birthday'] = $value;
    }

    public function getBirthdayAttribute($value)
    {
        return $value;
    }

    public function setCityAttribute($value)
    {
        $this->attributes['city'] = Crypt::encryptString($value);
    }

    public function getCityAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setNationalityAttribute($value)
    {
        $this->attributes['nationality'] = Crypt::encryptString($value);
    }

    public function getNationalityAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setGenderAttribute($value)
    {
        $this->attributes['gender'] = Crypt::encryptString($value);
    }

    public function getGenderAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    public function setReligionAttribute($value)
    {
        $this->attributes['religion'] = Crypt::encryptString($value);
    }

    public function getReligionAttribute($value)
    {
        return Crypt::decryptString($value);
    }

    // Relationship with User model
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
