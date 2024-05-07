<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PribadiController;
use App\Http\Controllers\MotherController;
use App\Http\Controllers\FatherController;


// Auth routes
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);

// Personal data routes
Route::post('personals', [PribadiController::class, 'store']);
Route::get('/personals', [PribadiController::class, 'index']);
Route::get('/personals/{id}', [PribadiController::class, 'show']);
Route::put('/personals/{id}', [PribadiController::class, 'update']);
Route::delete('/personals/{id}', [PribadiController::class, 'destroy']);

// Personal data routes
Route::post('mothers', [MotherController::class, 'store']);
// Personal data routes
Route::post('fathers', [FatherController::class, 'store']);

