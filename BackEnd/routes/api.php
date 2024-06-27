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
use App\Http\Controllers\BarcodeController;
use App\Http\Controllers\PdfController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\NotificationController;


// Auth routes
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::post('/password_request', [AuthController::class, 'passwordResetRequest']);
Route::post('/reset_password', [AuthController::class, 'resetPassword']);

// Group routes that require authentication
Route::middleware('auth:sanctum')->group(function () {
    // Personal data routes
    Route::get('/personals', [PribadiController::class, 'index']);
    Route::post('/personals', [PribadiController::class, 'store']);
    Route::post('/personals', [PribadiController::class, 'update']);

    /// User
    Route::get('user', [AuthController::class, 'getProfile']);
    Route::put('profile', [AuthController::class, 'updateProfile']);

    // Mother
    Route::post('mothers', [MotherController::class, 'store']);
    Route::get('mothers', [MotherController::class, 'index']);
    Route::put('mothers', [MotherController::class, 'update']);

    // Father
    Route::post('fathers', [FatherController::class, 'store']);
    Route::get('fathers', [FatherController::class, 'index']);
    Route::put('fathers', [FatherController::class, 'update']);

    // Works
    Route::post('works', [WorkController::class, 'store']);
    Route::get('works', [WorkController::class, 'index']);
    Route::put('works/{id}', [WorkController::class, 'update']);

    // Education
    Route::post('educations', [EducationController::class, 'store']);
    Route::get('educations', [EducationController::class, 'index']);
    Route::put('educations/{id}', [EducationController::class, 'update']);
    Route::delete('educations/{id}', [EducationController::class, 'destroy']);

    // Barcode and User card
    Route::post('/pdf/upload', [PdfController::class, 'uploadPdf']);
    Route::get('/pdf/download/{filename}', [PdfController::class, 'downloadPdf']);

    // Personal data routes
    Route::get('personal', [UserController::class, 'getPersonalData']);
        
    // Work data route
    Route::get('work', [UserController::class, 'getWorkData']);
    
    // Logout route
    Route::post('logout', [AuthController::class, 'logout']);
});

Route::post('/integration-history', [IntegrationHistoryController::class, 'store']);
Route::get('/integration-history', [IntegrationHistoryController::class, 'index']);

Route::post('/integration-history', [IntegrationHistoryController::class, 'store']);
Route::get('/integration-history', [IntegrationHistoryController::class, 'index']);
Route::get('/notifications', [NotificationController::class, 'index']);
Route::post('/notifications/{id}/mark-as-read', [NotificationController::class, 'markAsRead']);