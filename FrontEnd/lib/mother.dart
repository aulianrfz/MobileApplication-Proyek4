import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MotherFormInputPage extends StatefulWidget {
  @override
  _MotherFormInputPageState createState() => _MotherFormInputPageState();
}

class _MotherFormInputPageState extends State<MotherFormInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _selectedCityController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _selectedGenderController =
  TextEditingController();
  final TextEditingController _religionController = TextEditingController();

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
    'North Macedonia (formerly Macedonia)'
    , 'Norway',
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
    // Fetch data when the page loads
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/mothers'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _nikController.text = responseData['nik'];
          _nameController.text = responseData['name'];
          _addressController.text = responseData['address'];
          _selectedCity = responseData['city'];
          _nationalityController.text = responseData['nationality'];
          _selectedGender = responseData['gender'];
          _religionController.text = responseData['religion'];
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
        title: Text('Mother Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _nikController,
                  decoration: InputDecoration(
                    labelText: 'NIK',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: _validateNIK,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) => _validateInput(value, 'Name'),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) => _validateInput(value, 'Address'),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DropdownButtonFormField(
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
                    labelText: 'City',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) => _validateInput(value, 'City'),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _nationalityController,
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) => _validateInput(value, 'Nationality'),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DropdownButtonFormField(
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
                    labelText: 'Gender',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) => _validateInput(value, 'Gender'),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _religionController,
                  decoration: InputDecoration(
                    labelText: 'Religion',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) => _validateInput(value, 'Religion'),
                ),
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
                      // Handle the error if token is not found
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
      Uri.parse('http://localhost:8000/api/mothers'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If mother data already exists, update it
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/mothers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nik': _nikController.text,
          'name': _nameController.text,
          'address': _addressController.text,
          'city': _selectedCity,
          'nationality': _nationalityController.text,
          'gender': _selectedGender,
          'religion': _religionController.text,
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
      // If mother data does not exist, create it
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/mothers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nik': _nikController.text,
          'name': _nameController.text,
          'address': _addressController.text,
          'city': _selectedCity,
          'nationality': _nationalityController.text,
          'gender': _selectedGender,
          'religion': _religionController.text,
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

  String? _validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your NIK';
    } else if (!RegExp(r'^\d{10,20}$').hasMatch(value)) {
      return 'NIK must be a numeric value between 10 and 20 digits';
    }
    return null;
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
    home: MotherFormInputPage(),
  ));
}