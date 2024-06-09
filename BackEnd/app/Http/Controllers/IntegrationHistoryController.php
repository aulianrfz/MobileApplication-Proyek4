<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Models\History;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class IntegrationHistoryController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'app_name' => 'required|string|max:255',
            'generated_at' => 'required|date',
            'status' => 'required|string|max:255',
            'user_id' => 'required|integer',
        ]);

        History::create($validated);

        // Simpan notifikasi
        Notification::create([
            'user_id' => $validated['user_id'],
            'message' => 'Integrasi baru pada aplikasi: ' . $validated['app_name'],
            'read' => false
        ]);

        return response()->json(['message' => 'Integration history recorded successfully'], 200);
    }

    public function index(Request $request)
    {
        $histories = History::where('user_id', $request->user_id)->get();
        return response()->json($histories, 200);
    }
}
