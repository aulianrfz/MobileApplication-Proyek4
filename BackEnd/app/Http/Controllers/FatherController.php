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
        $father = $user->father;
        if (!$father) {
            return response()->json(['message' => 'Father data not found'], 404);
        }
        return response()->json(['data' => $father]);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nik' => 'required|unique:fathers,nik',
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $user = Auth::user();
        $father = Father::create(array_merge($validatedData, ['user_id' => $user->id]));

        return response()->json(['message' => 'Father data created successfully', 'data' => $father], 201);
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $father = $user->father;

        if (!$father) {
            return response()->json(['message' => 'Father data not found'], 404);
        }

        $validatedData = $request->validate([
            'nik' => 'required|unique:fathers,nik,' . $father->id,
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $father->update($validatedData);

        return response()->json(['message' => 'Father data updated successfully', 'data' => $father], 200);
    }

    // You can implement 'show' and 'destroy' methods similarly if needed
}
