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
        $motherData = $user->mother()->first();

        if ($motherData) {
            return response()->json([
                'data' => [
                    'nik' => $motherData->nik,
                    'nama' => $motherData->nama,
                    'address' => $motherData->address,
                    'city' => $motherData->city,
                    'nationality' => $motherData->nationality,
                    'gender' => $motherData->gender,
                    'religion' => $motherData->religion,
                    'birthday' => $motherData->birthday,
                ]
            ]);
        }

        return response()->json(['data' => null]);
    }

    public function store(Request $request)
    {
        $user = Auth::user();
        $motherData = $request->only(['nik', 'nama', 'birthday', 'address', 'city', 'nationality', 'gender', 'religion']);

        $user->mother()->updateOrCreate([], $motherData);

        return response()->json(['message' => 'Mother data saved successfully']);
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $motherData = $request->only(['nik', 'nama', 'birthday', 'address', 'city', 'nationality', 'gender', 'religion']);

        $mother = $user->mother()->first();
        if ($mother) {
            $mother->update($motherData);
            return response()->json(['message' => 'Mother data updated successfully']);
        }

        return response()->json(['message' => 'Mother data not found'], 404);
    }
}
