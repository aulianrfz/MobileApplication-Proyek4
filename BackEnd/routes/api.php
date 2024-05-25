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

// Group routes that require authentication
Route::middleware('auth:sanctum')->group(function () {
    // Personal data routes
    Route::post('personals', [PribadiController::class, 'store']);
    Route::get('/personals', [PribadiController::class, 'index']);
    Route::get('/personals/{id}', [PribadiController::class, 'show']);
    Route::put('/personals/{id}', [PribadiController::class, 'update']);
    Route::delete('/personals/{id}', [PribadiController::class, 'destroy']);

    // Mother data routes
    Route::post('mothers', [MotherController::class, 'store']);

    // Father data routes
    Route::post('fathers', [FatherController::class, 'store']);

    // Logout route
    Route::post('logout', [AuthController::class, 'logout']);
});
