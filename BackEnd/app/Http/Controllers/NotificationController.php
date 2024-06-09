<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Notification;
use App\Http\Controllers\Controller;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $notifications = Notification::where('user_id', $request->user_id)->where('read', false)->get();
        return response()->json($notifications, 200);
    }

    public function markAsRead($id)
    {
        $notification = Notification::find($id);
        $notification->read = true;
        $notification->save();

        return response()->json(['message' => 'Notification marked as read'], 200);
    }
}
