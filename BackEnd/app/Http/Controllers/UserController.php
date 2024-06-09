<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Personal;
use App\Models\Work;

use PDF;

class UserController extends Controller
{
    public function getUserData($barcode) {
        $user = User::where('barcode', $barcode)->with(['personal', 'mother', 'father', 'work', 'education'])->first();

        if ($user) {
            return response()->json($user);
        } else {
            return response()->json(['message' => 'User not found'], 404);
        }
    }


    public function downloadPdf($barcode)
    {
        $user = User::where('barcode', $barcode)->with(['personal', 'mother', 'father', 'work', 'education'])->first();

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $pdf = PDF::loadView('user_card', compact('user'));

        return $pdf->download('user_card.pdf');
    }

    public function getPersonalData()
    {
        $personal = Personal::first(); // Assuming you only have one record in the 'personals' table
        if ($personal) {
            return response()->json([
                'firstName' => $personal->first_name,
                'lastName' => $personal->last_name,
            ]);
        } else {
            return response()->json(['error' => 'No personal data found'], 404);
        }
    }

    public function getWorklData()
    {
        $work = Work::first(); // Assuming you only have one record in the 'personals' table
        if ($work) {
            return response()->json([
                'position' => $work->first_name,
            ]);
        } else {
            return response()->json(['error' => 'No personal data found'], 404);
        }
    }
}
