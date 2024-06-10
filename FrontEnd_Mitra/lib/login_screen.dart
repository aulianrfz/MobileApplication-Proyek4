import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'shared_prefences.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                      color: Color(0xFF15144E),
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
                    color: Color(0xFF15144E),
                  ),
                ),
                SizedBox(height: 40),
                buildTextField('Email',
                    isPassword: false, controller: _emailController),
                SizedBox(height: 20),
                buildPasswordField('Password', controller: _passwordController),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF15144E),
                    ),
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(321, 51.91)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 15)),
                  ),
                  child: Text(
                    'login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/'); // Navigate to home
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 243, 33, 33),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label,
      {bool isPassword = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            validator: (value) {
              if (label == 'Email' && !value!.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField(String label,
      {required TextEditingController controller}) {
    bool _obscureText = true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _obscureText = !_obscureText;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8000/api/login'),
          body: {
            'email': email,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          // Login berhasil
          final responseData = json.decode(response.body);
          final token = responseData['token'];
          final userId =
              responseData['user_id']; // Dapatkan userId dari respons API

          // Simpan token dan userId ke dalam shared preferences
          await SharedPreferencesManager.saveUserData(token, userId);

          // Kirim data riwayat ke aplikasi integrasi
          final historyResponse = await http.post(
            Uri.parse('http://localhost:8000/api/integration-history'),
            headers: {
              'Authorization':
                  'Bearer $token', // Sertakan token jika diperlukan
            },
            body: {
              'app_name': 'QuickFy',
              'generated_at': DateTime.now().toIso8601String(),
              'status': 'Login successful',
              'user_id': userId.toString(),
            },
          );

          Navigator.pushReplacementNamed(context, '/');
        } else {
          // Gagal login
          _showErrorDialog(context, 'Login Failed', 'Gagal');
        }
      } catch (error) {
        // Tangani kesalahan jaringan atau kesalahan lainnya
        _showErrorDialog(context, 'Error', 'Kesalahan lain');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
