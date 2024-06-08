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
        \Log::info('Incoming request data: ', $request->all());

        $validatedData = $request->validate([
            'nik' => 'required|unique:mothers,nik',
            'name' => 'required',
            'address' => 'required',
            'city' => 'required',
            'nationality' => 'required',
            'gender' => 'required',
            'religion' => 'required',
        ]);

        \Log::info('Validated data: ', $validatedData);

        $user = Auth::user();
        $mother = Mother::create(array_merge($validatedData, ['user_id' => $user->id]));

        \Log::info('Created mother data: ', $mother->toArray());

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

        \Log::info('Validated data for update: ', $validatedData);

        $mother->update($validatedData);

        \Log::info('Updated mother data: ', $mother->toArray());

        return response()->json(['message' => 'Mother data updated successfully', 'data' => $mother], 200);
    }
}
