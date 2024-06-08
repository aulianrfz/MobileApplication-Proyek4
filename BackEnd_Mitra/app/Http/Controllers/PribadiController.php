<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Personal;
use Illuminate\Support\Facades\Auth;

class PribadiController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $personal = $user->personal;
        if (!$personal) {
            return response()->json(['message' => 'Personal data not found'], 404);
        }
        return response()->json(['data' => $personal]);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nik' => 'required|unique:personals,nik',
            'first_name' => 'required',
            'last_name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);
    
        $personal = Personal::create($validatedData);
    
        return response()->json(['message' => 'Personal data created successfully'], 201);
    }
    

    public function show()
    {
        $personalData = Personal::where('user_id', Auth::id())->get();

        return response()->json($personalData);
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $personal = $user->personal;

        if (!$personal) {
            return response()->json(['message' => 'Personal data not found'], 404);
        }

        $validatedData = $request->validate([
            'nik' => 'required|unique:personals,nik,' . $personal->id,
            'first_name' => 'required',
            'last_name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $personal->update($validatedData);

        return response()->json(['message' => 'Personal data updated successfully', 'data' => $personal], 200);
    }

    public function destroy()
    {
        $user = Auth::user();
        $personal = $user->personal;
        if (!$personal) {
            return response()->json(['message' => 'Personal data not found'], 404);
        }

        $personal->delete();

        return response()->json(['message' => 'Personal data deleted successfully']);
    }
}
