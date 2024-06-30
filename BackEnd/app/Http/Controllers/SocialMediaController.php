<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\SocialMedia;
use Illuminate\Support\Facades\Auth;

class SocialMediaController extends Controller
{
    /**
     * Display the specified resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = Auth::user();
        $socialMediaData = $user->socialMedia()->first();

        if ($socialMediaData) {
            return response()->json([
                'data' => [
                    'facebook' => $socialMediaData->facebook,
                    'instagram' => $socialMediaData->instagram,
                    'linkedIn' => $socialMediaData->linkedIn,
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

        $socialMediaData = $request->only(['facebook', 'instagram', 'linkedIn']);

        // If social media data already exists, update it; otherwise, create it.
        $user->socialMedia()->updateOrCreate([], $socialMediaData);

        return response()->json(['message' => 'Social media data saved successfully']);
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

        $socialMediaData = $request->only(['facebook', 'instagram', 'linkedIn']);

        // Find existing social media data and update it
        $socialMedia = $user->socialMedia()->first();
        if ($socialMedia) {
            $socialMedia->update($socialMediaData);
            return response()->json(['message' => 'Social media data updated successfully']);
        }

        return response()->json(['message' => 'Social media data not found'], 404);
    }
}
