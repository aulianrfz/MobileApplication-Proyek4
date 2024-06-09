<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Education;
use App\Models\Work;
use App\Models\Father;
use App\Models\Mother;
use App\Models\Personal;

class BarcodeController extends Controller
{
    public function getUserData(Request $request)
    {
        $barcode = $request->input('barcode');
        $user = User::where('barcode', $barcode)->first();

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $educations = Education::where('user_id', $user->id)->get();
        $works = Work::where('user_id', $user->id)->get();
        $father = Father::where('user_id', $user->id)->first();
        $mother = Mother::where('user_id', $user->id)->first();
        $personal = Personal::where('user_id', $user->id)->first();

        return response()->json([
            'user' => $user,
            'educations' => $educations,
            'works' => $works,
            'father' => $father,
            'mother' => $mother,
            'personal' => $personal
        ]);
    }
}
