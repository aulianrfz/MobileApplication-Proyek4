import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormInputPage extends StatefulWidget {
  @override
  _FormInputPageState createState() => _FormInputPageState();
}

class _FormInputPageState extends State<FormInputPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nikController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _selectedCityController = TextEditingController();
  TextEditingController _selectedGenderController = TextEditingController();
  TextEditingController _religionController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
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
              ElevatedButton(
                onPressed: () {
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
      Uri.parse('http://localhost:8000/api/personals'), // Adjust with the correct endpoint
      body: {
        'nik': _nikController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'address': _addressController.text,
        'city': _selectedCity,
        'nationality': _nationalityController.text,
        'gender': _selectedGender,
        'religion': _religionController.text,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data')),
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
