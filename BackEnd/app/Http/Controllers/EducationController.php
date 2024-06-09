<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Education;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class EducationController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $education = $user->education; // Assuming a user has many educations relationship
        return response()->json(['data' => $education]);
    }

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

    public function update(Request $request, $id)
    {
        Log::info('Request received for updating education data', ['request' => $request->all()]);

        $user = Auth::user();

        $request->validate([
            'school' => 'required|string',
            'start_year' => 'required|integer',
            'end_year' => 'required|integer',
            'major' => 'required|string',
            'address' => 'required|string',
            'city' => 'required|string',
        ]);

        try {
            $education = Education::where('user_id', $user->id)->findOrFail($id);
            $education->update([
                'school' => $request->input('school'),
                'start_year' => $request->input('start_year'),
                'end_year' => $request->input('end_year'),
                'major' => $request->input('major'),
                'address' => $request->input('address'),
                'city' => $request->input('city'),
            ]);

            Log::info('Education data updated successfully', ['user_id' => $user->id]);
            return response()->json(['message' => 'Education data updated successfully'], 200);
        } catch (\Exception $e) {
            Log::error('Failed to update education data', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to update education data'], 500);
        }
    }


    public function destroy($id)
    {
        $user = Auth::user();
        $education = Education::find($id);

        if (!$education || $education->user_id !== $user->id) {
            return response()->json(['message' => 'Education data not found or unauthorized'], 404);
        }

        $education->delete();

        return response()->json(['message' => 'Education data deleted successfully'], 200);
    }
}
