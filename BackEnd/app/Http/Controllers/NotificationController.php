<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Notification;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $notifications = Notification::where('user_id', $user->id)->get();
        return response()->json($notifications, 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'body' => 'required|string',
        ]);

        $user = Auth::user();

        $notification = Notification::create([
            'user_id' => $user->id,
            'title' => $request->title,
            'body' => $request->body,
        ]);

        return response()->json($notification, 201);
    }

    public function storeDirectly($userId, $title, $body)
    {
        Notification::create([
            'user_id' => $userId,
            'title' => $title,
            'body' => $body,
        ]);
    }

    public function show($id)
    {
        $user = Auth::user();
        $notification = Notification::where('id', $id)->where('user_id', $user->id)->first();

        if (!$notification) {
            return response()->json(['message' => 'Notification not found'], 404);
        }

        return response()->json($notification, 200);
    }
}
