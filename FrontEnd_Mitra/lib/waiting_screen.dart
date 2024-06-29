import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {
    super.initState();
    _listenForIntegrationResponse();
  }

  void _listenForIntegrationResponse() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['status'] == 'integration_response') {
        _handleIntegrationResponse(message.data['response']);
      }
    });
  }

  void _handleIntegrationResponse(String response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response == 'yes') {
      // Save flag to indicate successful integration
      prefs.setBool('integration_success', true);
    } else {
      // Clear any previously saved user data if integration failed
      prefs.remove('integration_success');
    }
    Navigator.pushNamedAndRemoveUntil(context, '/personal', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Waiting for integration response...'),
      ),
    );
  }
}
