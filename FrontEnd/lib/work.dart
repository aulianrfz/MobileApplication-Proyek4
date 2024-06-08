import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WorkFormInputPage extends StatefulWidget {
  @override
  _WorkFormInputPageState createState() => _WorkFormInputPageState();
}

class _WorkFormInputPageState extends State<WorkFormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _selectedCityController = TextEditingController();

  List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    // Add other cities as needed
  ];

  String _selectedCity = '';

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
        Uri.parse('http://localhost:8000/api/works'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        if (responseData is List && responseData.isNotEmpty) {
          final workData = responseData.first;
          setState(() {
            _npwpController.text = workData['npwp'];
            _companyController.text = workData['company'];
            _startYearController.text = workData['start_year'].toString();
            _endYearController.text = workData['end_year'].toString();
            _positionController.text = workData['position'];
            _addressController.text = workData['address'];
            _selectedCity = workData['city'];
          });
        } else {
          // If no data is found, initialize with empty values
          setState(() {
            _npwpController.text = '';
            _companyController.text = '';
            _startYearController.text = '';
            _endYearController.text = '';
            _positionController.text = '';
            _addressController.text = '';
            _selectedCity = '';
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
        title: Text('Work Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _npwpController,
                decoration: InputDecoration(labelText: 'NPWP'),
                validator: (value) => _validateInput(value, 'NPWP'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Company'),
                validator: (value) => _validateInput(value, 'Company'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startYearController,
                      decoration: InputDecoration(labelText: 'Start Year'),
                      validator: (value) => _validateInput(value, 'Start Year'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _endYearController,
                      decoration: InputDecoration(labelText: 'End Year'),
                      validator: (value) => _validateInput(value, 'End Year'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) => _validateInput(value, 'Position'),
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
              ElevatedButton(
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
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/works'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data'];
      if (responseData is List && responseData.isNotEmpty) {
        final response = await http.put(
          Uri.parse('http://localhost:8000/api/works'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'npwp': _npwpController.text,
            'company': _companyController.text,
            'start_year': _startYearController.text,
            'end_year': _endYearController.text,
            'position': _positionController.text,
            'address': _addressController.text,
            'city': _selectedCity,
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
      } else {
        final response = await http.post(
          Uri.parse('http://localhost:8000/api/works'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'npwp': _npwpController.text,
            'company': _companyController.text,
            'start_year': _startYearController.text,
            'end_year': _endYearController.text,
            'position': _positionController.text,
            'address': _addressController.text,
            'city': _selectedCity,
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
      }
    } else {
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
    home: WorkFormInputPage(),
  ));
}
