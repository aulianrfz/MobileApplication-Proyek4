<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateWorksTable extends Migration
{
    public function up()
    {
        Schema::create('works', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('npwp')->unique();
            $table->string('company');
            $table->integer('start_year');
            $table->integer('end_year');
            $table->string('position');
            $table->string('address');
            $table->string('city');
            $table->timestamps();

        });
    }

    public function down()
    {
        Schema::dropIfExists('works');
    }
}

