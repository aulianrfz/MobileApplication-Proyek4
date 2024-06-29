<?php

namespace App\Services;

use Google_Client;
use Illuminate\Support\Facades\Log;

class FirebaseNotificationService
{
    protected $client;

    public function __construct()
    {
        $this->client = new Google_Client();
        $this->client->setAuthConfig(storage_path('firebase/quickfy-7dfdd-firebase-adminsdk-e70q2-94c936e4e4.json'));
        $this->client->addScope('https://www.googleapis.com/auth/firebase.messaging');
    }

    public function sendFirebaseNotification($message)
    {
        $this->client->fetchAccessTokenWithAssertion();
        $accessToken = $this->client->getAccessToken()['access_token'];

        $url = 'https://fcm.googleapis.com/v1/projects/quickfy-7dfdd/messages:send';
        $headers = [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json'
        ];

        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode(['message' => $message]));

        $result = curl_exec($ch);
        if (curl_errno($ch)) {
            Log::error('Curl error: ' . curl_error($ch));
        }
        curl_close($ch);

        Log::info('Firebase response: ' . $result);
    }
}
