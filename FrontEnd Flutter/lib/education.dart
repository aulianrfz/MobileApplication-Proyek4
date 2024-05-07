import 'package:flutter/material.dart';

class EducationPage extends StatefulWidget {
  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
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

  Widget _buildDataContainer(
      String labelText, TextEditingController controller) {
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
        'city': TextEditingController(
            text: _cities.isNotEmpty ? _cities.first : null),
      });
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process data
      // For example, save the data to a database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EducationPage(),
  ));
}
