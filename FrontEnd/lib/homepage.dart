import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart'; // Import this package

// Dummy classes for HistoryPage and SettingPage to prevent errors
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with actual implementation
  }
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with actual implementation
  }
}

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
            buildBottomNavigationItem(context, Icons.account_circle, "Settings", 2),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildBottomNavigationItem(BuildContext context, IconData icon, String label, int index) {
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
              color: _selectedIndex == index ? Color(0xFF15144E) : Colors.grey,
            ),
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
  final GlobalKey _containerKey = GlobalKey();

  String? _photoUrl;
  String? _pdfUrl; // To store the generated PDF URL

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
          _photoUrl = responseData['photo']; // Store the photo URL
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

  Future<pw.Document> _generatePdf() async {
    final RenderRepaintBoundary boundary =
    _containerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              pw.MemoryImage(pngBytes),
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ),
    );

    return pdf;
  }

  Future<String> _savePdf(pw.Document pdf) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }

  Future<void> _generateAndOpenPdf() async {
    final pdf = await _generatePdf();
    final filePath = await _savePdf(pdf);
    await _openPdf(filePath);
    await _showBarcodeDialog(filePath);
  }

  Future<void> _openPdf(String filePath) async {
    await Printing.layoutPdf(
      onLayout: (format) async => File(filePath).readAsBytesSync(),
    );
  }

  Future<void> _showBarcodeDialog(String filePath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: BarcodeDialog(filePath),
        );
      },
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
              final pdf = await _generatePdf();
              final filePath = await _savePdf(pdf);
              await _showBarcodeDialog(filePath);
            },
            child: RepaintBoundary(
              key: _containerKey,
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
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : AssetImage('assets/profile.png') as ImageProvider,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_firstNameController.text} ${_lastNameController.text}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'NIK: ${_nikController.text}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Position: ${_positionController.text}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 80),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ColorChangeButton(
                text: 'Personal',
                color: Color.fromARGB(255, 244, 183, 205),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/personal');
                  await fetchData();
                },
              ),
              ColorChangeButton(
                text: 'Works',
                color: Color.fromARGB(255, 171, 146, 223),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/work');
                  await fetchData();
                },
              ),
              ColorChangeButton(
                text: 'Education',
                color: const Color(0xFFEADAF4),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/education');
                  await fetchData();
                },
              ),
              ColorChangeButton(
                text: 'Family',
                color: Color(0xFF7ADFCD),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/ortu');
                  await fetchData();
                },
              ),
              ColorChangeButton(
                text: 'Health',
                color: const Color(0xFF44EBEB),
                onPressed: () {},
              ),
              ColorChangeButton(
                text: 'Social Media',
                color: const Color(0xFFFFAE4F),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/sosmed');
                  await fetchData();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BarcodeDialog extends StatelessWidget {
  final String filePath;

  BarcodeDialog(this.filePath);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 200,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: 'file://$filePath',
            errorBuilder: (context, error) => Center(
              child: Text('Error generating barcode: $error'),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class ColorChangeButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  ColorChangeButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: Size(180, 100),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
