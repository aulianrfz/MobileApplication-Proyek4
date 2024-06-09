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
  final TextEditingController _selectedCityController = TextEditingController();
  final TextEditingController _selectedGenderController =
  TextEditingController();
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(
                controller: _nikController,
                label: 'NIK',
                validator: (value) => _validateInput(value, 'NIK'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _firstNameController,
                label: 'First Name',
                validator: (value) => _validateInput(value, 'First Name'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _lastNameController,
                label: 'Last Name',
                validator: (value) => _validateInput(value, 'Last Name'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _addressController,
                label: 'Address',
                validator: (value) => _validateInput(value, 'Address'),
              ),
              SizedBox(height: 16.0),
              _buildDropdownButtonFormField(
                value: _selectedCity,
                items: _cities,
                label: 'City',
                onChanged: (String? value) {
                  setState(() {
                    _selectedCity = value ?? '';
                  });
                },
                validator: (value) => _validateInput(value, 'City'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _nationalityController,
                label: 'Nationality',
                validator: (value) => _validateInput(value, 'Nationality'),
              ),
              SizedBox(height: 16.0),
              _buildDropdownButtonFormField(
                value: _selectedGender,
                items: _genders,
                label: 'Gender',
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value ?? '';
                  });
                },
                validator: (value) => _validateInput(value, 'Gender'),
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _religionController,
                label: 'Religion',
                validator: (value) => _validateInput(value, 'Religion'),
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
                        // Handle the error if token is not found
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
  }) {
    return TextFormField(
      controller: controller,
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

  Widget _buildDropdownButtonFormField({
    required String value,
    required List<String> items,
    required String label,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField(
      value: value.isNotEmpty ? value : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
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

  void _submitForm(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/personals'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If personal data already exists, update it
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/personals'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nik': _nikController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'address': _addressController.text,
          'city': _selectedCity,
          'nationality': _nationalityController.text,
          'gender': _selectedGender,
          'religion': _religionController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data')),
        );
        print('Failed to update data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else if (response.statusCode == 404) {
      // If personal data does not exist, create it
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/personals'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nik': _nikController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'address': _addressController.text,
          'city': _selectedCity,
          'nationality': _nationalityController.text,
          'gender': _selectedGender,
          'religion': _religionController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data')),
        );
        print('Failed to save data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
      print('Failed to fetch data: ${response.statusCode}');
      print('Response body: ${response.body}');
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
