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
      backgroundColor: Color(0xFF15144E),
      body: Center(
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
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Quick', // Teks pertama
                  ),
                  TextSpan(
                    text: 'Fy', // Teks kedua
                    style: TextStyle(
                      color: Color.fromARGB(255, 204, 31,
                          31), // Ubah warna teks 'Fy' menjadi hijau
                    ),
                  ),
                  TextSpan(
                    text: '!', // Teks kedua
                    style: TextStyle(
                      color: Color.fromARGB(255, 161, 239,
                          255), // Ubah warna teks 'Fy' menjadi hijau
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Q U I C K   I D E N T I F Y', // Teks kedua
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color.fromARGB(255, 161, 239, 255),
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                'login',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF15144E), // Ubah menjadi putih
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
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 163, 244, 255)),
              ),
              child: Text(
                'register',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: Color(0xFF15144E), // Ubah menjadi putih
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
