<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Education;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class EducationController extends Controller
{
    public function store(Request $request)
    {
        Log::info('Request received for storing education data', ['request' => $request->all()]);

        $user = Auth::user();

        $request->validate([
            'educations' => 'required|array',
            'educations.*.school' => 'required|string',
            'educations.*.start_year' => 'required|integer',
            'educations.*.end_year' => 'required|integer',
            'educations.*.major' => 'required|string',
            'educations.*.address' => 'required|string',
            'educations.*.city' => 'required|string',
        ]);

        $educations = collect($request->input('educations'))->map(function ($education) use ($user) {
            return [
                'user_id' => $user->id,
                'school' => $education['school'],
                'start_year' => $education['start_year'],
                'end_year' => $education['end_year'],
                'major' => $education['major'],
                'address' => $education['address'],
                'city' => $education['city'],
                'created_at' => now(),
                'updated_at' => now(),
            ];
        });

        try {
            Education::insert($educations->toArray());
            Log::info('Education data saved successfully', ['user_id' => $user->id]);
            return response()->json(['message' => 'Education data saved successfully'], 201);
        } catch (\Exception $e) {
            Log::error('Failed to save education data', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to save education data'], 500);
        }
    }
}
