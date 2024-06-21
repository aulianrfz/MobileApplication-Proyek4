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
  final TextEditingController _selectedNationalityController =
      TextEditingController();
  final TextEditingController _selectedCityController = TextEditingController();
  final TextEditingController _selectedGenderController =
      TextEditingController();
  final TextEditingController _selectedReligionController =
      TextEditingController();

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
  ];

  List<String> _nationalitys = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Congo-Brazzaville)',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czechia (Czech Republic)',
    'Democratic Republic of the Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini (fmr. "Swaziland")',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (formerly Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia (formerly Macedonia)',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine State',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States of America',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe'
  ];

  String _selectedCity = '';
  String _selectedGender = '';
  String _selectedReligion = '';
  String _selectedNationality = '';

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
          _selectedNationality = responseData['nationality'];
          _selectedGender = responseData['gender'];
          _selectedReligion = responseData['religion'];
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
                validator: _validateNIK,
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
              _buildDropdownButtonFormField(
                value: _selectedNationality,
                items: _nationalitys,
                label: 'Nationality',
                onChanged: (String? value) {
                  setState(() {
                    _selectedNationality = value ?? '';
                  });
                },
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
              _buildDropdownButtonFormField(
                value: _selectedReligion,
                items: _religions,
                label: 'Religion',
                onChanged: (String? value) {
                  setState(() {
                    _selectedReligion = value ?? '';
                  });
                },
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
          'nationality': _selectedNationality,
          'gender': _selectedGender,
          'religion': _selectedReligion,
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
          'nationality': _selectedNationality,
          'gender': _selectedGender,
          'religion': _selectedReligion,
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

  String? _validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your NIK';
    } else if (!RegExp(r'^\d{10,20}$').hasMatch(value)) {
      return 'NIK must be a numeric value between 10 and 20 digits';
    }
    return null;
  }
}

void main() {
  runApp(MaterialApp(
    home: FormInputPage(),
  ));
}
