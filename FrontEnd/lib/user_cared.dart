import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class UserCardPage extends StatefulWidget {
  final String barcode;

  UserCardPage({required this.barcode});

  @override
  _UserCardPageState createState() => _UserCardPageState();
}

class _UserCardPageState extends State<UserCardPage> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(Uri.parse('http://your_api_url/get_user_data/${widget.barcode}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Uint8List?> generatePdf(Map<String, dynamic> userData) async {
    final pdf = pdfLib.Document();
    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            children: [
              pdfLib.Text('Name: ${userData['name']}'),
              pdfLib.Text('Email: ${userData['email']}'),
              // Add other user data here...
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Card'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('User not found');
            } else {
              final userData = snapshot.data!;
              return ElevatedButton(
                onPressed: () async {
                  final pdfBytes = await generatePdf(userData);
                  // Implement logic to display PDF
                },
                child: Text('Download PDF'),
              );
            }
          },
        ),
      ),
    );
  }
}
