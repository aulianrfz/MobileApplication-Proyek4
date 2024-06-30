import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: HealthFormInputPage(),
  ));
}

class HealthFormInputPage extends StatefulWidget {
  @override
  _HealthFormInputPageState createState() => _HealthFormInputPageState();
}

class _HealthFormInputPageState extends State<HealthFormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodPressureController =
  TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();

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
        Uri.parse('http://localhost:8000/api/health'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        if (responseData != null) {
          setState(() {
            _bloodPressureController.text = responseData['bloodPressure'] ?? '';
            _bloodSugarController.text = responseData['bloodSugar'] ?? '';
            _heartRateController.text = responseData['heartRate'] ?? '';
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
        title: Text('Health Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(
                controller: _bloodPressureController,
                label: 'Blood Pressure',
                validator: (value) =>
                    _validateInput(value, 'Blood Pressure'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _bloodSugarController,
                label: 'Blood Sugar Level',
                obscureText: false,
                validator: (value) =>
                    _validateInput(value, 'Blood Sugar Level'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _heartRateController,
                label: 'Heart Rate',
                validator: (value) =>
                    _validateInput(value, 'Heart Rate'),
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
                    padding: EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 24.0),
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
        contentPadding:
        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
    final Map<String, dynamic> healthData = {
      'bloodPressure': _bloodPressureController.text.trim(),
      'bloodSugar': _bloodSugarController.text.trim(),
      'heartRate': _heartRateController.text.trim(),
    };

    final Uri url = Uri.parse('http://localhost:8000/api/health');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(healthData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully')),
      );
      // Clear form fields after successful submission
      _bloodPressureController.clear();
      _bloodSugarController.clear();
      _heartRateController.clear();
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
