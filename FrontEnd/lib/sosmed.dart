import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: SocialMediaFormInputPage(),
  ));
}

class SocialMediaFormInputPage extends StatefulWidget {
  @override
  _SocialMediaFormInputPageState createState() =>
      _SocialMediaFormInputPageState();
}

class _SocialMediaFormInputPageState extends State<SocialMediaFormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late encrypt.Encrypter _encrypter;

  @override
  void initState() {
    super.initState();
    _encrypter = _getEncrypter();
    fetchData();
  }

  encrypt.Encrypter _getEncrypter() {
    final key = encrypt.Key.fromLength(32);
    return encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/social_media'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        if (responseData != null) {
          setState(() {
            _facebookController.text = _decryptData(responseData['facebook']);
            _instagramController.text = _decryptData(responseData['instagram']);
            _linkedInController.text = responseData['linkedIn'];
          });
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  String _decryptData(String encryptedString) {
    final decrypted = _encrypter.decrypt64(encryptedString);
    return decrypted;
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
                validator: (value) =>
                    _validateInput(value, 'Facebook Username'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _instagramController,
                label: 'Instagram',
                obscureText: false, // Biarkan false untuk menampilkan teks asli
                validator: (value) => _validateInput(value, 'Instagram'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _linkedInController,
                label: 'LinkedIn Platform',
                validator: (value) =>
                    _validateInput(value, 'LinkedIn Platform'),
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
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
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
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
    final String facebook = _encryptData(_facebookController.text.trim());
    final String instagram = _encryptData(_instagramController.text.trim());

    final Map<String, dynamic> socialMediaData = {
      'facebook': facebook,
      'instagram': instagram,
      'linkedIn': _linkedInController.text.trim(),
    };

    final Uri url = Uri.parse('http://10.0.2.2:8000/api/social_media');

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data')),
      );
      print('Failed to save data: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  String _encryptData(String data) {
    final encrypted = _encrypter.encrypt(data);
    return encrypted.base64;
  }
}
