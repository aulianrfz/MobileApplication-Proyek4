import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EducationFormInputPage extends StatefulWidget {
  @override
  _EducationFormInputPageState createState() => _EducationFormInputPageState();
}

class _EducationFormInputPageState extends State<EducationFormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Depok',
    'Tangerang',
    'South Tangerang',
    'Bekasi',
    'Washington, D.C.', // Amerika Serikat
    'London', // Inggris
    'Paris', // Prancis
    'Berlin', // Jerman
    'Moscow', // Rusia
    'Beijing', // Tiongkok
    'Tokyo', // Jepang
    'Rome', // Italia
    'Madrid', // Spanyol
    'Ottawa', // Kanada
    'Canberra', // Australia
    'Brasília', // Brasil
    'New Delhi', // India
    'Islamabad', // Pakistan
    'Bangkok', // Thailand
    'Hanoi', // Vietnam
    'Seoul', // Korea Selatan
    'Ankara', // Turki
    'Cairo', // Mesir
    'Nairobi', // Kenya
    'Athens', // Yunani
    'Amsterdam', // Belanda
    'Oslo', // Norwegia
    'Stockholm', // Swedia
    'Copenhagen', // Denmark
    'Helsinki', // Finlandia
    'Brussels', // Belgia
    'Vienna', // Austria
    'Warsaw', // Polandia
    'Budapest', // Hungaria
    'Bucharest', // Rumania
    'Prague', // Republik Ceko
    'Dublin', // Irlandia
    'Lisbon', // Portugal
    'Buenos Aires', // Argentina
    'Santiago', // Chili
    'Lima', // Peru
    'Mexico City', // Meksiko
  ];

  String _selectedCity = ''; // Set a default value
  int? _educationId;

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
        Uri.parse('http://localhost:8000/api/educations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        if (responseData != null) {
          setState(() {
            _educationId = responseData['id'];
            _schoolController.text = responseData['school'];
            _startYearController.text = responseData['start_year'].toString();
            _endYearController.text = responseData['end_year'].toString();
            _majorController.text = responseData['major'];
            _addressController.text = responseData['address'];
            _selectedCity = responseData['city'];

            // Ensure the selected city is in the list
            if (!_cities.contains(_selectedCity)) {
              _cities.add(_selectedCity);
            }
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
        title: Text('Education Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(
                controller: _schoolController,
                label: 'School',
                validator: (value) => _validateInput(value, 'School'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: _startYearController,
                      label: 'Start Year',
                      validator: (value) => _validateInput(value, 'Start Year'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextFormField(
                      controller: _endYearController,
                      label: 'End Year',
                      validator: (value) => _validateInput(value, 'End Year'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _majorController,
                label: 'Major',
                validator: (value) => _validateInput(value, 'Major'),
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

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  void _submitForm(String token) async {
    final String school = _schoolController.text;
    final String startYear = _startYearController.text;
    final String endYear = _endYearController.text;

    // Validate input fields
    if (_validateInput(school, 'School') != null ||
        _validateInput(startYear, 'Start Year') != null ||
        _validateInput(endYear, 'End Year') != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Validate start_year and end_year
    if (int.parse(startYear) >= int.parse(endYear)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Start year must be before end year')),
      );
      return;
    }

    final Map<String, dynamic> educationData = {
      'school': school,
      'start_year': startYear,
      'end_year': endYear,
      'major': _majorController.text,
      'address': _addressController.text,
      'city': _selectedCity,
    };

    final Uri url = _educationId != null
        ? Uri.parse('http://localhost:8000/api/educations/$_educationId')
        : Uri.parse('http://localhost:8000/api/educations');

    final response = await (_educationId != null
        ? http.put(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(educationData),
          )
        : http.post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'educations': [educationData]
            }), // Wrap data in 'educations' array
          ));

    if ((response.statusCode == 200 && _educationId != null) ||
        (response.statusCode == 201 && _educationId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully')),
      );
      if (_educationId == null) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _educationId = responseData['id'];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data')),
      );
      print('Failed to save data: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EducationFormInputPage(),
  ));
}
