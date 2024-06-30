<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Father;
use Illuminate\Support\Facades\Auth;

class FatherController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $fatherData = $user->father()->first();

        if ($fatherData) {
            return response()->json([
                'data' => [
                    'nik' => $fatherData->nik,
                    'nama' => $fatherData->nama,
                    'address' => $fatherData->address,
                    'city' => $fatherData->city,
                    'nationality' => $fatherData->nationality,
                    'gender' => $fatherData->gender,
                    'religion' => $fatherData->religion,
                    'birthday' => $fatherData->birthday,
                ]
            ]);
        }

        return response()->json(['data' => null]);
    }

    public function store(Request $request)
    {
        $user = Auth::user();
        $fatherData = $request->only(['nik', 'nama', 'birthday', 'address', 'city', 'nationality', 'gender', 'religion']);

        $user->father()->updateOrCreate([], $fatherData);

        return response()->json(['message' => 'Father data saved successfully']);
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $fatherData = $request->only(['nik', 'nama', 'birthday', 'address', 'city', 'nationality', 'gender', 'religion']);

        $father = $user->father()->first();
        if ($father) {
            $father->update($fatherData);
            return response()->json(['message' => 'Father data updated successfully']);
        }

        return response()->json(['message' => 'Father data not found'], 404);
    }
}
