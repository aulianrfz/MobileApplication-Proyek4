<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Father;

class FatherController extends Controller
{
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nik' => 'required|unique:fathers',
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $father = Father::create($validatedData);

        return response()->json(['message' => 'Personal data created successfully', 'data' => $father]);
    }
}
