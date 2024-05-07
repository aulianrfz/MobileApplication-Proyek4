<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('fathers', function (Blueprint $table) {
            $table->id();
            $table->string('nik')->unique();
            $table->string('name');
            $table->string('address');
            $table->string('city');
            $table->string('nationality');
            $table->string('gender');
            $table->string('religion');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('fathers');
    }
};
