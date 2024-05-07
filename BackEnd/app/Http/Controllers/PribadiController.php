<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Personal;

class PribadiController extends Controller
{
    public function index()
    {
        $personals = Personal::all();
        return response()->json(['data' => $personals]);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'nik' => 'required|unique:personals',
            'first_name' => 'required',
            'last_name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $personal = Personal::create($validatedData);

        return response()->json(['message' => 'Personal data created successfully', 'data' => $personal]);
    }

    public function show($id)
    {
        $personal = Personal::find($id);
        if (!$personal) {
            return response()->json(['message' => 'Personal data not found'], 404);
        }
        return response()->json(['data' => $personal]);
    }

    public function update(Request $request, $id)
    {
        $personal = Personal::find($id);
        if (!$personal) {
            return response()->json(['message' => 'Personal data not found'], 404);
        }

        $validatedData = $request->validate([
            'nik' => 'required|unique:personals,nik,' . $id,
            'first_name' => 'required',
            'last_name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        $personal->update($validatedData);

        return response()->json(['message' => 'Personal data updated successfully', 'data' => $personal]);
    }

    public function destroy($id)
    {
        $personal = Personal::find($id);
        if (!$personal) {
            return response()->json(['message' => 'Personal data not found'], 404);
        }

        $personal->delete();

        return response()->json(['message' => 'Personal data deleted successfully']);
    }
}
