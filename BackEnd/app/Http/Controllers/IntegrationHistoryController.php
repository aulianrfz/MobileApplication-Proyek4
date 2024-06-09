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
        ]);

        History::create($validated);

        return response()->json(['message' => 'Integration history recorded successfully'], 200);
    }

    public function index()
    {
        $histories = History::all();
        return response()->json($histories, 200);
    }
}
