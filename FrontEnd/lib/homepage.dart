import 'package:flutter/material.dart';
import 'package:singpass/history.dart';
import 'package:singpass/setting.dart';
import 'package:singpass/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    HistoryPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildBottomNavigationItem(context, Icons.home, "Home", 0),
            buildBottomNavigationItem(context, Icons.history, "History", 1),
            buildBottomNavigationItem(
                context, Icons.account_circle, "Settings", 2),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildBottomNavigationItem(
      BuildContext context, IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Color(0xFF15144E) : Colors.grey,
            size: 35,
          ),
          Text(
            label,
            style: TextStyle(
                color:
                    _selectedIndex == index ? Color(0xFF15144E) : Colors.grey),
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nikController;
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _nikController = TextEditingController();
    _positionController = TextEditingController();
    fetchData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nikController.dispose();
    _positionController.dispose();
    super.dispose();
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
          _firstNameController.text = responseData['first_name'];
          _lastNameController.text = responseData['last_name'];
          _nikController.text = responseData['nik'];
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/works'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _positionController.text = responseData['position'];
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('NIK: ${_nikController.text}',
                    style: pw.TextStyle(fontSize: 20)),
                pw.Text(
                    'Name: ${_firstNameController.text} ${_lastNameController.text}',
                    style: pw.TextStyle(fontSize: 20)),
                pw.Text('Position: ${_positionController.text}',
                    style: pw.TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<String> _savePdf(Uint8List pdfBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/profile.pdf');
    await file.writeAsBytes(pdfBytes);
    return file.path;
  }

  Future<void> _openPdf(String filePath) async {
    await Printing.layoutPdf(
      onLayout: (format) async => File(filePath).readAsBytesSync(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Welcome back, ${_firstNameController.text}!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              final pdfBytes = await _generatePdf();
              final filePath = await _savePdf(pdfBytes);
              await _openPdf(filePath);
            },
            child: Container(
              width: double.infinity,
              height: 165,
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _nikController.text,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${_firstNameController.text} ${_lastNameController.text}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _positionController.text,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Identity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ColorChangeButton(
                text: 'Personal',
                color: Color.fromARGB(255, 244, 183, 205),
                onTap: () {
                  Navigator.pushNamed(context, '/personal');
                },
              ),
              ColorChangeButton(
                text: 'Works',
                color: Color.fromARGB(255, 171, 146, 223),
                onTap: () {
                  Navigator.pushNamed(context, '/work');
                },
              ),
              ColorChangeButton(
                text: 'Education',
                color: const Color(0xFFEADAF4),
                onTap: () {
                  Navigator.pushNamed(context, '/education');
                },
              ),
              ColorChangeButton(
                text: 'Family',
                color: Color(0xFF7ADFCD),
                onTap: () {
                  Navigator.pushNamed(context, '/ortu');
                },
              ),
              ColorChangeButton(
                text: 'Health',
                color: const Color(0xFF44EBEB),
                onTap: () {},
              ),
              ColorChangeButton(
                text: 'Passport',
                color: const Color(0xFFFFAE4F),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
