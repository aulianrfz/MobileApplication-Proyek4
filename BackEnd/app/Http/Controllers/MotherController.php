<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mother;
use Illuminate\Support\Facades\Auth;

class MotherController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $mother = $user->mother;
        if (!$mother) {
            return response()->json(['message' => 'Mother data not found'], 404);
        }
        return response()->json(['data' => $mother]);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nik' => 'required|unique:mothers,nik',
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $user = Auth::user();
        $mother = Mother::create(array_merge($validatedData, ['user_id' => $user->id]));

        return response()->json(['message' => 'Mother data created successfully', 'data' => $mother], 201);
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $mother = $user->mother;

        if (!$mother) {
            return response()->json(['message' => 'Mother data not found'], 404);
        }

        $validatedData = $request->validate([
            'nik' => 'required|unique:mothers,nik,' . $mother->id,
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $mother->update($validatedData);

        return response()->json(['message' => 'Mother data updated successfully', 'data' => $mother], 200);
    }



    // Other methods like show, update, and destroy can be implemented similarly
}
