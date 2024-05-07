<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mother;

class MotherController extends Controller
{
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nik' => 'required|unique:mothers',
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $mother = Mother::create($validatedData);

        return response()->json(['message' => 'Mother data created successfully', 'data' => $mother]);
    }
}
