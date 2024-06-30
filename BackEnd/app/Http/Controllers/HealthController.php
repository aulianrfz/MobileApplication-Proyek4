<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Health;
use Illuminate\Support\Facades\Auth;

class HealthController extends Controller
{
    /**
     * Display the specified resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = Auth::user();
        $healthData = $user->health()->first();

        if ($healthData) {
            return response()->json([
                'data' => [
                    'bloodPressure' => $healthData->bloodPressure,
                    'bloodSugar' => $healthData->bloodSugar,
                    'heartRate' => $healthData->heartRate,
                ]
            ]);
        }

        return response()->json(['data' => null]);
    }

    /**
     * Store or update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $user = Auth::user();
        $healthData = $request->only(['bloodPressure', 'bloodSugar', 'heartRate']);

        // If health data already exists, update it; otherwise, create it.
        $user->health()->updateOrCreate([], $healthData);

        return response()->json(['message' => 'Health data saved successfully']);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        $user = Auth::user();
        $healthData = $request->only(['bloodPressure', 'bloodSugar', 'heartRate']);

        // Find existing health data and update it
        $health = $user->health()->first();
        if ($health) {
            $health->update($healthData);
            return response()->json(['message' => 'Health data updated successfully']);
        }

        return response()->json(['message' => 'Health data not found'], 404);
    }
}
