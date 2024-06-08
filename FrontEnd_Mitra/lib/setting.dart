import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8081/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _nameController.text = responseData['name'];
          _emailController.text = responseData['email'];
          _phoneController.text = responseData['phone'];
        });
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout Confirmation'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Clear token and navigate to HomeScreen
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Update Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save Changes'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showLogoutConfirmationDialog,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    // Your profile update logic here
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingPage(),
  ));
}
