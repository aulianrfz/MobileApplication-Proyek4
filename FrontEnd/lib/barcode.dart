import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BarcodePage(),
    );
  }
}

class BarcodePage extends StatefulWidget {
  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  String barcode = "User-barcode"; // Ganti dengan nilai unik untuk pengguna

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Barcode"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: barcode,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserCardPage(barcode: barcode),
                  ),
                );
              },
              child: Text("Generate Barcode"),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCardPage extends StatelessWidget {
  final String barcode;

  UserCardPage({required this.barcode});

  Future<void> downloadPdf(BuildContext context) async {
    final url = 'http://localhost:8000/download_pdf/$barcode'; // Perbaiki penulisan 'localhost'
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final base64Pdf = base64Encode(response.bodyBytes);
        final pdfUrl = 'data:application/pdf;base64,$base64Pdf';
        launch(pdfUrl);
      } else {
        print('Failed to download PDF');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF')),
        );
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Card"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => downloadPdf(context),
          child: Text("Download PDF"),
        ),
      ),
    );
  }
}
