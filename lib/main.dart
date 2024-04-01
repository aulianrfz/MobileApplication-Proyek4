import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontSize: 20),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome back, Jimmy!'),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your notification action here
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Add your settings action here
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Jimmy Anderson',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Graphic Designer',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Personal'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Works'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Health'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Education'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Family'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                child: Text('Passport'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Add your home action here
                },
              ),
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  // Add your history action here
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  // Add your account action here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
