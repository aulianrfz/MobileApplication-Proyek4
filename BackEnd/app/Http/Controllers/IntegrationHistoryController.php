<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\History;

class IntegrationHistoryController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'app_name' => 'required|string|max:255',
            'generated_at' => 'required|date',
            'status' => 'required|string|max:255',
            'user_id' => 'required|exists:users,id', // Validasi user_id
        ]);

        History::create($validated);

        return response()->json(['message' => 'Integration history recorded successfully'], 200);
    }

    public function index(Request $request)
    {
        $userId = $request->query('user_id');

        if ($userId) {
            $histories = History::where('user_id', $userId)->get();
        } else {
            $histories = History::all();
        }

        return response()->json($histories, 200);
    }
}
