<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Personal;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class PribadiController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();

        // Ensure you have the correct user ID and model relationship set up
        $person = Personal::where('user_id', $user->id)->first();

        if ($person) {
            // Form the correct photo URL
            $photoUrl = $person->photo ? url('storage/' . $person->photo) : null;

            return response()->json([
                'data' => [
                    'nik' => $person->nik,
                    'first_name' => $person->first_name,
                    'last_name' => $person->last_name,
                    'address' => $person->address,
                    'city' => $person->city,
                    'nationality' => $person->nationality,
                    'gender' => $person->gender,
                    'religion' => $person->religion,
                    'photo' => $photoUrl,
                ]
            ]);
        }

        return response()->json(['message' => 'Personal data not found'], 404);
    }
    public function update(Request $request)
    {
        $user = $request->user();

        // Validation
        $validator = Validator::make($request->all(), [
            'nik' => 'required|string|size:16',
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'city' => 'required|string|max:255',
            'nationality' => 'required|string|max:255',
            'gender' => 'required|string|max:10',
            'religion' => 'required|string|max:255',
            'photo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            Log::error('Validation failed: ', $validator->errors()->toArray());
            return response()->json(['status' => 'error', 'message' => $validator->errors()], 400);
        }

        Log::info('Incoming request data: ', $request->all());

        // Fetch or create personal data
        $personal = Personal::firstOrCreate(
            ['user_id' => $user->id],
            [
                'nik' => $request->nik,
                'first_name' => $request->first_name,
                'last_name' => $request->last_name,
                'address' => $request->address,
                'city' => $request->city,
                'nationality' => $request->nationality,
                'gender' => $request->gender,
                'religion' => $request->religion,
            ]
        );

        Log::info('Personal data after firstOrCreate: ', $personal->toArray());

        // Update personal data
        $personal->nik = $request->nik;
        $personal->first_name = $request->first_name;
        $personal->last_name = $request->last_name;
        $personal->address = $request->address;
        $personal->city = $request->city;
        $personal->nationality = $request->nationality;
        $personal->gender = $request->gender;
        $personal->religion = $request->religion;

        // Handle file upload
        if ($request->hasFile('photo')) {
            Log::info('File upload detected.');

            // Delete old photo if exists
            if ($personal->photo) {
                Log::info('Deleting old photo: ' . $personal->photo);
                Storage::disk('public')->delete($personal->photo);
            }

            $photo = $request->file('photo');
            $photoPath = $photo->store('photos', 'public');
            $personal->photo = $photoPath;

            Log::info('New photo stored at: ' . $photoPath);
        }

        // Save the updated personal data
        if ($personal->save()) {
            Log::info('Personal data saved successfully: ', $personal->toArray());
            return response()->json(['status' => 'success', 'data' => $personal], 200);
        } else {
            Log::error('Failed to save personal data');
            return response()->json(['status' => 'error', 'message' => 'Failed to update data'], 500);
        }
    }
}
