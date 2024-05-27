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
  List<Map<String, TextEditingController>> _educations = [];

  List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    // Tambahkan kota lain sesuai kebutuhan
  ];

  @override
  void initState() {
    super.initState();
    _addEducation(); // Add initial education entry
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Education'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int index = 0; index < _educations.length; index++)
                _buildEducationContainer(index),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addEducation,
                child: Text('Add Education'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationContainer(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education ${index + 1}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildDataContainer('School', _educations[index]['school']!),
        _buildDataContainer('Start Year', _educations[index]['startYear']!),
        _buildDataContainer('End Year', _educations[index]['endYear']!),
        _buildDataContainer('Major', _educations[index]['major']!),
        _buildDataContainer('Address', _educations[index]['address']!),
        _buildDataContainer('City', _educations[index]['city']!),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDataContainer(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _addEducation() {
    setState(() {
      _educations.add({
        'school': TextEditingController(),
        'startYear': TextEditingController(),
        'endYear': TextEditingController(),
        'major': TextEditingController(),
        'address': TextEditingController(),
        'city': TextEditingController(text: _cities.isNotEmpty ? _cities.first : null),
      });
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token != null) {
        final List<Map<String, dynamic>> educationData = _educations
            .map((education) => {
          'school': education['school']!.text,
          'start_year': education['startYear']!.text,
          'end_year': education['endYear']!.text,
          'major': education['major']!.text,
          'address': education['address']!.text,
          'city': education['city']!.text,
        })
            .toList();

        try {
          final response = await http.post(
            Uri.parse('http://localhost:8000/api/educations'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({'educations': educationData}),
          );

          if (response.statusCode == 201) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Education data saved successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save education data')),
            );
            print('Failed to save education data: ${response.statusCode}');
            print('Response body: ${response.body}');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred while saving education data')),
          );
          print('Error occurred while saving education data: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token not found')),
        );
      }
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EducationFormInputPage(),
  ));
}
