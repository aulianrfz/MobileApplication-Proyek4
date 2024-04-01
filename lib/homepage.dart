import 'package:flutter/material.dart';
import 'package:singpass/personal.dart';


class Homepage extends StatelessWidget {
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
                    'Welcome back, Jimmy!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Container for personal information
              Container(
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
                          'Jimmy Anderson',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Graphic Designer',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                      // Add your on-tap logic here
                    },
                  ),

                  // Education button
                  ColorChangeButton(
                    text: 'Education',
                    color: const Color(0xFFB5F16A),
                    onTap: () {
                      // Add your on-tap logic here
                    },
                  ),

                  // Family button
                  ColorChangeButton(
                    text: 'Family',
                    color: const Color(0xFFFB7575),
                    onTap: () {
                      // Add your on-tap logic here
                    },
                  ),

                  // Health button
                  ColorChangeButton(
                    text: 'Health',
                    color: const Color(0xFF44EBEB),
                    onTap: () {
                      // Add your on-tap logic here
                    },
                  ),

                  // Passport button
                  ColorChangeButton(
                    text: 'Passport',
                    color: const Color(0xFFFFAE4F),
                    onTap: () {
                      // Add your on-tap logic here
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
                  // Add your on-tap logic here
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
