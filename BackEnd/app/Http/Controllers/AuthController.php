<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Kreait\Firebase\Factory;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
    /**
     * Handle a login request to the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    public function __construct()
    {
        try {
            $firebase = (new Factory)->withServiceAccount(config('firebase.credentials.file'));
            $this->messaging = $firebase->createMessaging();
            Log::info('Firebase initialized successfully.');
        } catch (\Exception $e) {
            Log::error('Error initializing Firebase: ' . $e->getMessage());
        }
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|max:15|unique:users',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $hashedPassword = hash('sha256', $request->password);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => $hashedPassword, // Enkripsi kata sandi
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json(['message' => 'User registered successfully', 'token' => $token], 201);
    }


    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string',
            'quickfy_fcm_token' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $hashedPassword = hash('sha256', $request->password);

        Log::info('Password in database: ' . $user->password);
        Log::info('Password entered: ' . $request->password);
        Log::info('Hashed password: ' . $hashedPassword);

        if ($hashedPassword !== $user->password) {
            Log::info('Invalid password for user ID: ' . $user->id);
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        $user->quickfy_fcm_token = $request->quickfy_fcm_token;
        $user->save();

        return response()->json(['message' => 'Login successful', 'token' => $token, 'user_id' => $user->id], 200);
    }


    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully'], 200);
    }

    // In AuthController.php
    public function updateProfile(Request $request)
    {
        $user = Auth::user();

        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
            'phone' => 'required|string|max:15',
        ]);

        $user->name = $validatedData['name'];
        $user->email = $validatedData['email'];
        $user->phone = $validatedData['phone'];
        $user->save();

        return response()->json(['message' => 'Profile updated successfully', 'data' => $user]);
    }


    // In AuthController.php
    public function getProfile()
    {
        $user = Auth::user();
        return response()->json(['data' => $user]);
    }

    public function passwordResetRequest(Request $request)
    {
        $request->validate(['email' => 'required|email|exists:users,email']);

        $token = Str::random(60);
        $email = $request->email;

        // Store the token with the email (or user ID) in your password resets table
        DB::table('password_resets')->insert([
            'email' => $email,
            'token' => Hash::make($token),
            'created_at' => now(),
        ]);

        // Send email with the token (or a link containing the token)
        Mail::send('emails.password_reset', ['token' => $token], function ($message) use ($email) {
            $message->to($email);
            $message->subject('Password Reset Request');
        });

        return response()->json(['message' => 'Password reset instructions have been sent to your email.'], 200);
    }

    // Add this method to handle password reset
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'Email not found.'], 404);
        }

        $user->password = hash('sha256', $request->password); // Menggunakan SHA-256
        $user->save();

        return response()->json(['message' => 'Password reset successfully.'], 200);
    }




}
