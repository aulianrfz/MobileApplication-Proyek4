import 'package:flutter/material.dart';

class WorkPage extends StatefulWidget {
  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _startYearController = TextEditingController();
  TextEditingController _endYearController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String _selectedCity = '';

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
        title: Text('Work'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDataContainer(
                'Company',
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your company',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your company';
                    }
                    return null;
                  },
                ),
              ),
              _buildYearInputContainer(),
              _buildDataContainer(
                'Position',
                TextFormField(
                  controller: _positionController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your position',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your position';
                    }
                    return null;
                  },
                ),
              ),
              _buildDataContainer(
                'Address',
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
              ),
              _buildDataContainer(
                'City',
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
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your City';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data
                    // For example, save the data to a database
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearInputContainer() {
    return _buildDataContainer(
      'Year',
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _startYearController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Start Year',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter start year';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _endYearController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'End Year',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter end year';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataContainer(String labelText, Widget child) {
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
          child: child,
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WorkPage(),
  ));
}
