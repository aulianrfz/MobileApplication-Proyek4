<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Personal;
use App\Models\Mother;
use App\Models\Father;
use App\Models\Work;
use App\Models\Education;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function run()
    {
        // Membuat user dengan data terkait
        $user = User::create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'phone' => '123456789',
            'password' => bcrypt('password'),
        ]);

        $user->personal()->create([
            'nik' => '1234567890',
            'first_name' => 'John',
            'last_name' => 'Doe',
            'birthdate' => '1990-01-01',
            'address' => '123 Main St',
            'city' => 'Anytown',
            'nationality' => 'USA',
            'gender' => 'Male',
            'religion' => 'Christian',
        ]);

        $user->mother()->create([
            'nik' => '2345678901',
            'name' => 'Jane Doe',
            'address' => '123 Main St',
            'city' => 'Anytown',
            'nationality' => 'USA',
            'gender' => 'Female',
            'religion' => 'Christian',
        ]);

        $user->father()->create([
            'nik' => '3456789012',
            'name' => 'Joe Doe',
            'address' => '123 Main St',
            'city' => 'Anytown',
            'nationality' => 'USA',
            'gender' => 'Male',
            'religion' => 'Christian',
        ]);

        $user->work()->create([
            'npwp' => '123456789',
            'company' => 'ABC Corp',
            'start_year' => 2015,
            'end_year' => 2020,
            'position' => 'Developer',
            'address' => '456 Business Rd',
            'city' => 'Businesstown',
        ]);

        $user->education()->create([
            'school' => 'Anytown University',
            'start_year' => '2010',
            'end_year' => '2014',
            'major' => 'Computer Science',
            'address' => '789 University Ave',
            'city' => 'Educationtown',
        ]);
    }
};
