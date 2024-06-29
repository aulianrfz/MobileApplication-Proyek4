<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;
use Illuminate\Support\Facades\Log;
use Google_Client;
use App\Services\FirebaseNotificationService;
use App\Http\Controllers\NotificationController;
use App\Models\Notification;
use App\Models\History;

class IntegrationController extends Controller
{
    protected $messaging;
    protected $firebaseNotification;
    protected $notificationController;

    public function __construct(FirebaseNotificationService $firebaseNotification, NotificationController $notificationController)
    {
        try {
            $firebase = (new Factory)->withServiceAccount(config('firebase.credentials.file'));
            $this->messaging = $firebase->createMessaging();
            Log::info('Firebase initialized successfully.');
        } catch (\Exception $e) {
            Log::error('Error initializing Firebase: ' . $e->getMessage());
        }
        $this->firebaseNotification = $firebaseNotification;
        $this->notificationController = $notificationController;
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
            'fcm_token' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        Log::info('Login attempt for email: ' . $request->email);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            Log::info('User not found for email: ' . $request->email);
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $hashedPassword = hash('sha256', $request->password);

        if ($hashedPassword !== $user->password) {
            Log::info('Invalid password for user ID: ' . $user->id);
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        Log::info('User authenticated: ' . $user->id);

        $token = $user->createToken('auth_token')->plainTextToken;

        // Simpan token FCM untuk aplikasi Quickfy
        $user->fcm_token = $request->fcm_token;
        $user->save();

        try {
            $this->sendLoginNotification($user->id);
            Log::info('Login notification sent successfully.');
        } catch (\Exception $e) {
            Log::error('Error sending login notification: ' . $e->getMessage());
        }

        Log::info('User logged in: ' . $user->id . ' with FCM token: ' . $user->fcm_token);

        return response()->json(['message' => 'Login successful', 'token' => $token, 'user_id' => $user->id], 200);
    }


    protected function sendLoginNotification($userId)
    {
        $user = User::find($userId);

        if (!$user || !$user->quickfy_fcm_token) {
            throw new \Exception('User or FCM token not found');
        }

        $title = 'Integrasi Berhasil';
        $body = 'Login berhasil dan terdapat integrasi dengan aplikasi mitra';

        $message = [
            'token' => $user->quickfy_fcm_token,
            'notification' => [
                'title' => $title,
                'body' => $body,
            ],
            'data' => [
                'user_id' => (string) $userId,
                'status' => 'Login successful'
            ]
        ];

        // Kirim notifikasi ke Firebase
        $this->firebaseNotification->sendFirebaseNotification($message);

        // Simpan notifikasi ke dalam database
        $this->notificationController->storeDirectly($userId, $title, $body);
    }

    public function handleNotificationResponse(Request $request)
    {
        $user = Auth::user();

        $request->validate([
            'id' => 'required|integer',
            'response' => 'required|string|in:yes,no',
        ]);

        $notification = Notification::where('id', $request->id)
            ->where('user_id', $user->id)
            ->first();

        if (!$notification) {
            return response()->json(['message' => 'Notification not found'], 404);
        }

        try {
            if ($request->response == 'yes') {
                $this->sendResponseToMitra($user->fcm_token, 'yes');

                // Record history
                History::create([
                    'app_name' => 'Quickfy',
                    'generated_at' => now(),
                    'status' => 'Integration approved',
                    'user_id' => $user->id,
                ]);
            } else {
                $this->sendResponseToMitra($user->fcm_token, 'no');
            }
            Log::info('Response sent successfully.');
        } catch (\Exception $e) {
            Log::error('Error sending response: ' . $e->getMessage());
        }

        return response()->json(['message' => 'Response received successfully'], 200);
    }


    protected function sendResponseToMitra($fcmToken, $response)
    {
        $message = [
            'token' => $fcmToken,
            'data' => [
                'status' => 'integration_response',
                'response' => $response,
            ],
        ];

        $this->firebaseNotification->sendFirebaseNotification($message);
    }

    public function handleIntegrationResponse(Request $request)
    {
        Log::info('handleIntegrationResponse called with response: ' . $request->input('response'));

        $response = $request->input('response');

        if ($response == 'yes') {
            // Simpan history
            History::create([
                'app_name' => 'Mitra',
                'generated_at' => now(),
                'status' => 'Login successful',
                'user_id' => Auth::id(),
            ]);

            // Lanjutkan logika integrasi lainnya...
            Log::info('History saved successfully.');
        }

        return response()->json(['status' => 'success']);
    }
}
