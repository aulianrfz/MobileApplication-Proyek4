import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: SocialMediaFormInputPage(),
  ));
}

class SocialMediaFormInputPage extends StatefulWidget {
  @override
  _SocialMediaFormInputPageState createState() => _SocialMediaFormInputPageState();
}

class _SocialMediaFormInputPageState extends State<SocialMediaFormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/social_media'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        if (responseData != null) {
          setState(() {
            _facebookController.text = responseData['facebook'] ?? '';
            _instagramController.text = responseData['instagram'] ?? '';
            _linkedInController.text = responseData['linkedIn'] ?? '';
          });
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(
                controller: _facebookController,
                label: 'Facebook Username',
                validator: (value) => _validateInput(value, 'Facebook Username'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _instagramController,
                label: 'Instagram',
                obscureText: false,
                validator: (value) => _validateInput(value, 'Instagram'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _linkedInController,
                label: 'LinkedIn',
                validator: (value) => _validateInput(value, 'LinkedIn '),
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String? token = prefs.getString('token');

                      if (token != null) {
                        _submitForm(token);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Token not found')),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    child: Text('Save', style: TextStyle(fontSize: 16.0)),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
      validator: validator,
    );
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  void _submitForm(String token) async {
    final Map<String, dynamic> socialMediaData = {
      'facebook': _facebookController.text.trim(),
      'instagram': _instagramController.text.trim(),
      'linkedIn': _linkedInController.text.trim(),
    };

    final Uri url = Uri.parse('http://localhost:8000/api/social_media');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(socialMediaData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully')),
      );
      // Clear form fields after successful submission
      _facebookController.clear();
      _instagramController.clear();
      _linkedInController.clear();
      // Update UI with new data after successful save
      fetchData(); // optionally, update UI immediately
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data')),
      );
      print('Failed to save data: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
