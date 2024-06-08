import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FormInputPage extends StatefulWidget {
  @override
  _FormInputPageState createState() => _FormInputPageState();
}

class _FormInputPageState extends State<FormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();

  List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    // Add other cities as needed
  ];

  List<String> _genders = [
    'Male',
    'Female',
    'Other',
  ];

  List<String> _religions = [
    'Christianity',
    'Islam',
    'Hinduism',
    'Buddhism',
    'Judaism',
    // Add other religions as needed
  ];

  String _selectedCity = '';
  String _selectedGender = '';
  String _selectedReligion = '';

  @override
  void initState() {
    super.initState();
    // Fetch data when the page loads
    fetchData();
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
          _nikController.text = responseData['nik'];
          _firstNameController.text = responseData['first_name'];
          _lastNameController.text = responseData['last_name'];
          _addressController.text = responseData['address'];
          _selectedCity = responseData['city'];
          _nationalityController.text = responseData['nationality'];
          _selectedGender = responseData['gender'];
          _religionController.text = responseData['religion'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        automaticallyImplyLeading: false, // Hide back button
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK'),
                validator: (value) => _validateInput(value, 'NIK'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) => _validateInput(value, 'First Name'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => _validateInput(value, 'Last Name'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => _validateInput(value, 'Address'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedCity.isNotEmpty ? _selectedCity : null,
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCity = value ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => _validateInput(value, 'City'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nationalityController,
                decoration: InputDecoration(labelText: 'Nationality'),
                validator: (value) => _validateInput(value, 'Nationality'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _selectedGender.isNotEmpty ? _selectedGender : null,
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) => _validateInput(value, 'Gender'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _religionController,
                decoration: InputDecoration(labelText: 'Religion'),
                validator: (value) => _validateInput(value, 'Religion'),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Generate with QuickFY?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    final response = await http.post(
      Uri.parse('http://localhost:8081/api/personals'),
      body: {
        'nik': _nikController.text.trim(),
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity.trim(),
        'nationality': _nationalityController.text.trim(),
        'gender': _selectedGender.trim(),
        'religion': _religionController.text.trim(),
      },
    );

    if (response.statusCode == 201) {
      // Registration successful, navigate to login screen
      Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      // Registration failed, display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text('An error occurred during registration.'),
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

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }
}

void main() {
  runApp(MaterialApp(
    home: FormInputPage(),
  ));
}
