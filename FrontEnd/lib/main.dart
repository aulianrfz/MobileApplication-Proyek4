import 'package:flutter/material.dart';
import 'package:singpass/login_screen.dart';
import 'package:singpass/register_screen.dart';
import 'package:singpass/homepage.dart';
import 'package:singpass/personal.dart';
import 'package:singpass/history.dart';
import 'package:singpass/work.dart';
import 'package:singpass/education.dart';
import 'package:singpass/setting.dart';
import 'package:singpass/ortu.dart';
import 'package:singpass/mother.dart';
import 'package:singpass/father.dart';
import 'package:singpass/barcode.dart';
import 'package:singpass/notification.dart';
//import 'package:singpass/user_card.dart';

void main() {
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
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/homepage': (context) => Homepage(),
        '/personal': (context) => FormInputPage(),
        '/setting': (context) => SettingPage(),
        '/history': (context) => HistoryPage(),
        '/education': (context) => EducationFormInputPage(),
        '/work': (context) => WorkFormInputPage(),
        '/ortu': (context) => FormOrtu(),
        '/mother': (context) => MotherFormInputPage(),
        '/father': (context) => FatherFormInputPage(),
        '/barcode': (context) => BarcodePage(),
        '/notifications': (context) => NotificationsPage(),
        //'/card': (context) => UserCardPage(),
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
