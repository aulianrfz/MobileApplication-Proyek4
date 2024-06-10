import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_data.dart';
import 'father.dart';
import 'api_service.dart';

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
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

  List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix'
  ];
  List<String> _genders = ['Male', 'Female', 'Other'];

  String _selectedCity = '';
  String _selectedGender = '';

  Map<String, String> _fatherData = {
    'nik': '',
    'name': '',
    'address': '',
    'city': '',
    'gender': '',
  };

  UserData? _userData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userData = await ApiService.fetchUserData();

    if (userData != null) {
      setState(() {
        _userData = userData;
        _nikController.text = userData.nik;
        _firstNameController.text = userData.firstName;
        _lastNameController.text = userData.lastName;
        _addressController.text = userData.address;
        _selectedCity = userData.city;
        _selectedGender = userData.gender;
      });
    } else {
      print('Failed to fetch user data');
    }
  }

  void _saveFatherData(Map<String, String> data) {
    setState(() {
      _fatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pengisian'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color.fromARGB(
            255, 210, 210, 209), // Change this to the desired background color
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nikController,
                  decoration: InputDecoration(
                    labelText: 'NIK',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => _validateInput(value, 'NIK'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => _validateInput(value, 'First Name'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => _validateInput(value, 'Last Name'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => _validateInput(value, 'City'),
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
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => _validateInput(value, 'Gender'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _facebookController,
                  decoration: InputDecoration(
                    labelText: 'Facebook',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  // You can add validation or customize as needed
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _twitterController,
                  decoration: InputDecoration(
                    labelText: 'Twitter',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  // You can add validation or customize as needed
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _instagramController,
                  decoration: InputDecoration(
                    labelText: 'Instagram',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  // You can add validation or customize as needed
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    _navigateToFatherFormPage(context);
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Generate with QuickFY?',
                      style: TextStyle(
                        color: Color(0xFF15144E),
                        decoration: TextDecoration.underline,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
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

  void _navigateToFatherFormPage(BuildContext context) async {
    final Map<String, String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FatherFormPage(
          onSubmitFatherForm: _saveFatherData,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _fatherData = result;
      });
    }
  }

  void _submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://localhost:8081/api/personals'),
        headers: {'Authorization': 'Bearer $token'},
        body: json.encode({
          'nik': _nikController.text.trim(),
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'address': _addressController.text.trim(),
          'city': _selectedCity.trim(),
          'gender': _selectedGender.trim(),
          'facebook': _facebookController.text.trim(),
          'twitter': _twitterController.text.trim(),
          'instagram': _instagramController.text.trim(),
          'father': _fatherData,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
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
    } else {
      print('Token not found');
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
