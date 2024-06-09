import 'package:flutter/material.dart';
import 'package:singpass/work.dart';
import 'package:singpass/personal.dart'; // Pastikan import yang diperlukan sudah tersedia.
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nikController;
  late TextEditingController _positionController;



  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _nikController = TextEditingController();
    _positionController = TextEditingController();
    fetchData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nikController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/personals'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _firstNameController.text = responseData['first_name'];
          _lastNameController.text = responseData['last_name'];
          _nikController.text = responseData['nik'];

        });
      } else {
        // Handle if failed to fetch data from backend
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      // Handle if token not found
      print('Token not found');
    }

    //work
    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/works'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _positionController.text = responseData['position'];
        });
      } else {
        // Handle if failed to fetch data from backend
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      // Handle if token not found
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 35,
                  ),
                  Icon(
                    Icons.settings,
                    size: 35,
                  ),
                ],
              ),

              // Center the welcome text
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Welcome back, ${_firstNameController.text}!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Container for personal information
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/barcode');
                },
                child: Container(
                  width: double.infinity,
                  height: 165,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Background circles

                      // Profile image
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                      SizedBox(width: 20), // Spacer

                      // Name and Role text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _nikController.text,                            style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${_firstNameController.text} ${_lastNameController.text}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _positionController.text,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Identity text
              Text(
                'Identity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              // Buttons
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  // Personal button
                  ColorChangeButton(
                    text: 'Personal',
                    color: const Color(0xFFFA3C81),
                    onTap: () {
                      Navigator.pushNamed(context, '/personal');
                    },
                  ),

                  // Works button
                  ColorChangeButton(
                    text: 'Works',
                    color: const Color(0xFF996AFD),
                    onTap: () {
                      Navigator.pushNamed(context, '/work');
                    },
                  ),

                  // Education button
                  ColorChangeButton(
                    text: 'Education',
                    color: const Color(0xFFB5F16A),
                    onTap: () {
                      Navigator.pushNamed(context, '/education');
                    },
                  ),

                  // Family button
                  ColorChangeButton(
                    text: 'Family',
                    color: const Color(0xFFFB7575),
                    onTap: () {
                      Navigator.pushNamed(context, '/ortu');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Bottom app bar
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          elevation: 20,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  // Add your on-tap logic here
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                  // Add your on-tap logic here
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/setting'); // Navigasi ke laman /setting
                },
              ),
            ],
          ),
        ),

        // Floating action button location
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class ColorChangeButton extends StatefulWidget {
  final String text;
  final Color color;
  final Function onTap;

  const ColorChangeButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  _ColorChangeButtonState createState() => _ColorChangeButtonState();
}

class _ColorChangeButtonState extends State<ColorChangeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        width: 175,
        height: 105,
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey.withOpacity(0.6) : widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isPressed ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
