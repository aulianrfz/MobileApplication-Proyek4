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
        $work = Work::find($id);

        if (!$work || $work->user_id !== $user->id) {
            return response()->json(['message' => 'Work data not found or unauthorized'], 404);
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

        $work->update($validatedData);

        return response()->json(['message' => 'Work data updated successfully', 'data' => $work], 200);
    }
}
