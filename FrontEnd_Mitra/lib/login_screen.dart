import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'shared_prefences.dart'; // Pastikan nama file ini benar
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['status'] == 'integration_response') {
        _handleIntegrationResponse(message.data['response']);
      }
    });

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _handleIntegrationResponse(String response) {
    if (response == 'yes') {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      // Handle "no" response if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15144E),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Quick',
                      ),
                      TextSpan(
                        text: 'Fy',
                        style: TextStyle(
                          color: Color.fromARGB(255, 204, 31, 31),
                        ),
                      ),
                      TextSpan(
                        text: '!',
                        style: TextStyle(
                          color: Color.fromARGB(255, 161, 239, 255),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Q U I C K   I D E N T I F Y',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF15144E),
                  ),
                ),
                SizedBox(height: 40),
                CustomTextField(
                  label: 'Email',
                  isPassword: false,
                  controller: _emailController,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Password',
                  isPassword: true,
                  controller: _passwordController,
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF15144E),
                    ),
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(321, 51.91)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 15)),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 243, 33, 33),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        print('Failed to obtain FCM token.');
        return;
      }
      print('Token: $fcmToken');

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/login_quickfy'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password, // Kirimkan password mentah
            'fcm_token': fcmToken,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final token = responseData['token'];
          final userId = responseData['user_id'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setInt('userId', userId);

          await SharedPreferencesManager.saveUserData(token, userId);

          // Navigate to the waiting screen
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/waiting_screen');
          }
        } else {
          print('Login failed: ${response.statusCode}');
          print('Response body: ${response.body}');
          _showErrorDialog(context, 'Login Failed', 'Gagal');
        }
      } catch (error) {
        print('Login: $error');
        _showErrorDialog(context, 'Error', 'Kesalahan lain');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    required this.label,
    required this.isPassword,
    required this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            validator: (value) {
              if (widget.label == 'Email' && !value!.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
