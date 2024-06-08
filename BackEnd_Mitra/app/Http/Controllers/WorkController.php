<?php

namespace App\Http\Controllers;

use App\Models\Work;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class WorkController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $work = $user->work;
        if (!$work) {
            return response()->json(['message' => 'Work data not found'], 404);
        }
        return response()->json(['data' => $work]);
    }
   
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'npwp' => 'required|unique:works,npwp',
            'company' => 'required',
            'start_year' => 'required|integer',
            'end_year' => 'required|integer',
            'position' => 'required',
            'address' => 'required',
            'city' => 'required',
        ]);

        $user = Auth::user();
        $work = Work::create(array_merge($validatedData, ['user_id' => $user->id]));

        return response()->json(['message' => 'Work data created successfully', 'data' => $work], 201);
    }

    public function update(Request $request, $id)
    {
        $user = Auth::user();
        $work = $user->works()->find($id);

        if (!$work) {
            return response()->json(['message' => 'Work data not found'], 404);
        }

        $validatedData = $request->validate([
            'npwp' => 'required|unique:works,npwp,' . $work->id,
            'company' => 'required',
            'start_year' => 'required|integer',
            'end_year' => 'required|integer',
            'position' => 'required',
            'address' => 'required',
            'city' => 'required',
        ]);

        \Log::info('Validated data for update: ', $validatedData);

        $work->update($validatedData);

        \Log::info('Updated mother data: ', $work->toArray());

        return response()->json(['message' => 'Work data updated successfully', 'data' => $work], 200);
    }
    // Implement other methods like update, show, and destroy as needed
}
