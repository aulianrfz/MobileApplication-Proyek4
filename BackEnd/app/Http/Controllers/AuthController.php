<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|max:20|unique:users',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => bcrypt($request->password),
        ]);

        return response()->json(['message' => 'User registered successfully'], 201);
    }

    public function login(Request $request)
    {
        // Ambil email dan password dari request
        $email = $request->input('email');
        $password = $request->input('password');

        // Cari user berdasarkan email
        $user = User::where('email', $email)->first();

        // Jika user ditemukan dan password cocok
        if ($user && Hash::check($password, $user->password)) {
            // Kembalikan data user sebagai respons
            return response()->json($user, 200);
        }

        // Jika user tidak ditemukan atau password tidak cocok, kembalikan respons Unauthorized
        return response()->json(['message' => 'Unauthorized'], 401);
    }
}
