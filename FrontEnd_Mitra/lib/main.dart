import 'package:flutter/material.dart';
import 'package:app_mitra/login_screen.dart';
import 'package:app_mitra/register_screen.dart';
import 'package:app_mitra/homepage.dart';
import 'package:app_mitra/setting.dart';
import 'package:app_mitra/personal.dart';
import 'package:app_mitra/father.dart';
import 'package:app_mitra/shared_prefences.dart'; // Import SharedPreferencesManager

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan WidgetsBinding telah diinisialisasi

  // Membersihkan token saat aplikasi pertama kali dibuka
  await SharedPreferencesManager.clearUserData(); // Bersihkan token

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FormInputPage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/homepage': (context) => Homepage(),
        '/setting': (context) => SettingPage(),
        '/personal': (context) => FormInputPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('.'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'QuickFy',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900], // Ubah menjadi biru gelap
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(321, 51.91)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Perpetua',
                  fontSize: 20,
                  color: Colors.white, // Ubah menjadi putih
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(321, 51.91)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Perpetua',
                  fontSize: 20,
                  color: Colors.white, // Ubah menjadi putih
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
