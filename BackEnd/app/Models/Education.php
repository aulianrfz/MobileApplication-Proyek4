<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Education extends Model
{
    use HasFactory;
    protected $table = 'educations';


    protected $fillable = [
        'user_id',
        'school',
        'start_year',
        'end_year',
        'major',
        'address',
        'city',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
