import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:singpass/firebase_options.dart';
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
import 'package:singpass/health.dart';
import 'package:singpass/barcode.dart';
import 'package:singpass/sosmed.dart';
import 'package:singpass/forgot_password.dart';
import 'package:singpass/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:singpass/shared_prefences.dart'; // Import SharedPreferencesManager

//import 'package:singpass/user_card.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SharedPreferencesManager.clearUserData();
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
        '/forgot_password': (context) => ForgotPasswordScreen(),
        '/homepage': (context) => Homepage(),
        '/personal': (context) => FormInputPage(),
        '/setting': (context) => SettingPage(),
        '/history': (context) => HistoryPage(),
        '/education': (context) => EducationFormInputPage(),
        '/work': (context) => WorkFormInputPage(),
        '/ortu': (context) => FormOrtu(),
        '/mother': (context) => MotherFormInputPage(),
        '/father': (context) => FatherFormInputPage(),
        '/health': (context) => HealthFormInputPage(),
        '/barcode': (context) => BarcodePage(),
        '/sosmed': (context) => SocialMediaFormInputPage(),
        '/notifications': (context) => NotificationsPage(),
        //'/card': (context) => UserCardPage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(jsonDecode(response.payload!));
          Navigator.pushNamed(
            context,
            '/notifications',
            arguments: data['user_id'],
          );
        }
      },
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _showNotification(notification, message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    Map<String, dynamic> data = message.data;
    Navigator.pushNamed(
      context,
      '/notifications',
      arguments: data['user_id'],
    );
  }

  void _showNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: jsonEncode(data),
    );
  }

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
                  color: Color(0xFF15144E),
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
                  color: Color(0xFF15144E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
