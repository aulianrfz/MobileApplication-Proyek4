import 'package:flutter/material.dart';
import 'package:app_mitra/api_service.dart'; // Sesuaikan dengan lokasi ApiService Anda
import 'user_data.dart';

class FatherFormPage extends StatefulWidget {
  final Function(Map<String, String>) onSubmitFatherForm;

  FatherFormPage({required this.onSubmitFatherForm});

  @override
  _FatherFormPageState createState() => _FatherFormPageState();
}

class _FatherFormPageState extends State<FatherFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fatherNikController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherAddressController =
      TextEditingController();
  final TextEditingController _fatherNationalityController =
      TextEditingController();
  final TextEditingController _fatherReligionController =
      TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _fetchFatherData();
  }

  Future<void> _fetchFatherData() async {
    final fatherData = await ApiService.fetchFatherData();

    if (fatherData != null) {
      setState(() {
        _fatherNikController.text = fatherData['nik'];
        _fatherNameController.text = fatherData['name'];
        _fatherAddressController.text = fatherData['address'];
        _selectedCity = fatherData['city'];
        _fatherNationalityController.text = fatherData['nationality'];
        _selectedGender = fatherData['gender'];
        _fatherReligionController.text = fatherData['religion'];
      });
    } else {
      // Handle failure to fetch father data
      print('Failed to fetch father data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Father\'s Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _fatherNikController,
                decoration: InputDecoration(labelText: 'Father\'s NIK'),
                validator: (value) => _validateInput(value, 'Father\'s NIK'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fatherNameController,
                decoration: InputDecoration(labelText: 'Father\'s Name'),
                validator: (value) => _validateInput(value, 'Father\'s Name'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fatherAddressController,
                decoration: InputDecoration(labelText: 'Father\'s Address'),
                validator: (value) =>
                    _validateInput(value, 'Father\'s Address'),
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
                decoration: InputDecoration(labelText: 'Father\'s City'),
                validator: (value) => _validateInput(value, 'Father\'s City'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fatherNationalityController,
                decoration: InputDecoration(labelText: 'Father\'s Nationality'),
                validator: (value) =>
                    _validateInput(value, 'Father\'s Nationality'),
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
                decoration: InputDecoration(labelText: 'Father\'s Gender'),
                validator: (value) => _validateInput(value, 'Father\'s Gender'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fatherReligionController,
                decoration: InputDecoration(labelText: 'Father\'s Religion'),
                validator: (value) =>
                    _validateInput(value, 'Father\'s Religion'),
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

  void _submitForm() {
    widget.onSubmitFatherForm({
      'nik': _fatherNikController.text.trim(),
      'name': _fatherNameController.text.trim(),
      'address': _fatherAddressController.text.trim(),
      'city': _selectedCity.trim(),
      'nationality': _fatherNationalityController.text.trim(),
      'gender': _selectedGender.trim(),
      'religion': _fatherReligionController.text.trim(),
    });
    Navigator.pop(context); // Close the FatherFormPage after saving
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter the $fieldName';
    }
    return null;
  }
}
