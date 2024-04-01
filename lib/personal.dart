import 'package:flutter/material.dart';

class FormInputPage extends StatefulWidget {
  @override
  _FormInputPageState createState() => _FormInputPageState();
}

class _FormInputPageState extends State<FormInputPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nikController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _religionController = TextEditingController();
  String _selectedCity = '';
  String _selectedNationality = '';
  String _selectedGender = '';
  String _selectedReligion = '';

  List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    // Tambahkan kota lain sesuai kebutuhan
  ];

  List<String> _nationalities = [
    'American',
    'British',
    'Chinese',
    'Indian',
    'Japanese',
    // Tambahkan kewarganegaraan lain sesuai kebutuhan
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
    // Tambahkan agama lain sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Personal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Tambahkan fungsi untuk mengedit
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDataContainer(
                  'NIK',
                  TextFormField(
                    controller: _nikController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your NIK';
                      }
                      return null;
                    },
                  ),
                ),
                _buildNameContainers(),
                _buildDateInputContainer(),
                _buildDataContainer(
                  'Address',
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Address';
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
                _buildDataContainer(
                  'Nationality',
                  DropdownButtonFormField(
                    value: _selectedNationality.isNotEmpty ? _selectedNationality : null,
                    items: _nationalities.map((String nationality) {
                      return DropdownMenuItem<String>(
                        value: nationality,
                        child: Text(nationality),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedNationality = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your Nationality';
                      }
                      return null;
                    },
                  ),
                ),
                _buildDataContainer(
                  'Gender',
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
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your Gender';
                      }
                      return null;
                    },
                  ),
                ),
                _buildDataContainer(
                  'Religion',
                  DropdownButtonFormField(
                    value: _selectedReligion.isNotEmpty ? _selectedReligion : null,
                    items: _religions.map((String religion) {
                      return DropdownMenuItem<String>(
                        value: religion,
                        child: Text(religion),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedReligion = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your Religion';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          // For example, save the data to a database
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Icon(Icons.check, color: Colors.white),
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

  Widget _buildNameContainers() {
    return Row(
      children: [
        Expanded(
          child: _buildDataContainer(
            'First Name',
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your First Name';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildDataContainer(
            'Last Name',
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Last Name';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInputContainer() {
    return _buildDataContainer(
      'Birthday',
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : '',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your Birthday';
                }
                return null;
              },
              readOnly: true,
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: FormInputPage(),
  ));
}