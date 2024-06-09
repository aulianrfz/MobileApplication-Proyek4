<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PribadiController;
use App\Http\Controllers\MotherController;
use App\Http\Controllers\FatherController;
use App\Http\Controllers\WorkController;
use App\Http\Controllers\EducationController;
use App\Http\Controllers\HistoryController;
use App\Http\Controllers\IntegrationHistoryController;


// Auth routes
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);

// Group routes that require authentication
Route::middleware('auth:sanctum')->group(function () {
    // Personal data routes
    Route::post('personals', [PribadiController::class, 'store']);
    Route::get('/personals', [PribadiController::class, 'index']);
    Route::put('personals', [PribadiController::class, 'update']);
    Route::delete('/personals/{id}', [PribadiController::class, 'destroy']);

    //user
    Route::get('user', [AuthController::class, 'getProfile']);
    Route::put('profile', [AuthController::class, 'updateProfile']);

    
    Route::post('mothers', [MotherController::class, 'store']);
    Route::get('mothers', [MotherController::class, 'index']);
    Route::put('mothers', [MotherController::class, 'update']);

    Route::post('fathers', [FatherController::class, 'store']);
    Route::get('fathers', [FatherController::class, 'index']);
    Route::put('fathers', [FatherController::class, 'update']);

    //works
    Route::post('works', [WorkController::class, 'store']);
    Route::get('works', [WorkController::class, 'index']);
    Route::put('works', [WorkController::class, 'update']);


    // education 
    Route::post('educations', [EducationController::class, 'store']);
    Route::get('educations', [EducationController::class, 'index']);

    // Logout route
    Route::post('logout', [AuthController::class, 'logout']);
});

Route::post('/integration-history', [IntegrationHistoryController::class, 'store']);
Route::get('/integration-history', [IntegrationHistoryController::class, 'index']);
