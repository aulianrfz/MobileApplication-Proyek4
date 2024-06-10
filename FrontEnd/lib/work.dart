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

  String _selectedCity = '';
  int? _workId;

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
        if (responseData != null) {
          setState(() {
            _workId = responseData['id'];
            _npwpController.text = responseData['npwp'];
            _companyController.text = responseData['company'];
            _startYearController.text = responseData['start_year'].toString();
            _endYearController.text = responseData['end_year'].toString();
            _positionController.text = responseData['position'];
            _addressController.text = responseData['address'];
            _selectedCity = responseData['city'];
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
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextFormField(
                controller: _npwpController,
                label: 'NPWP',
                validator: _validateNPWP,
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _companyController,
                label: 'Company',
                validator: (value) => _validateInput(value, 'Company'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: _startYearController,
                      label: 'Start Year',
                      validator: _validateStartYear,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: _buildTextFormField(
                      controller: _endYearController,
                      label: 'End Year',
                      validator: _validateEndYear,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: _positionController,
                label: 'Position',
                validator: (value) => _validateInput(value, 'Position'),
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
    final Map<String, dynamic> workData = {
      'npwp': _npwpController.text,
      'company': _companyController.text,
      'start_year': _startYearController.text,
      'end_year': _endYearController.text,
      'position': _positionController.text,
      'address': _addressController.text,
      'city': _selectedCity,
    };

    final Uri url = _workId != null
        ? Uri.parse('http://localhost:8000/api/works/$_workId')
        : Uri.parse('http://localhost:8000/api/works');

    final response = await (_workId != null
        ? http.put(
      url,headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
      body: json.encode(workData),
    )
        : http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(workData),
    ));

    if ((response.statusCode == 200 && _workId != null) ||
        (response.statusCode == 201 && _workId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully')),
      );
      if (_workId == null) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _workId = responseData['id'];
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

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  String? _validateNPWP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your NPWP';
    } else if (!RegExp(r'^\d{10,20}$').hasMatch(value)) {
      return 'NPWP must be a numeric value between 10 and 20 digits';
    }
    return null;
  }
  String? _validateStartYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Start Year';
    }
    if (_endYearController.text.isNotEmpty &&
        int.tryParse(value) != null &&
        int.tryParse(_endYearController.text) != null) {
      int startYear = int.parse(value);
      int endYear = int.parse(_endYearController.text);
      if (startYear > endYear) {
        return 'Start Year cannot be greater than End Year';
      }
    }
    return null;
  }

  String? _validateEndYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the End Year';
    }
    if (_startYearController.text.isNotEmpty &&
        int.tryParse(value) != null &&
        int.tryParse(_startYearController.text) != null) {
      int startYear = int.parse(_startYearController.text);
      int endYear = int.parse(value);
      if (endYear < startYear) {
        return 'End Year cannot be less than Start Year';
      }
    }
    return null;
  }

}

void main() {
  runApp(MaterialApp(
    home: WorkFormInputPage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
    ),
  ));
}
