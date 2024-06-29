import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryPage> {
  List<dynamic> history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        print('Token is null');
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/histories'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Status 200');
        setState(() {
          print('Setting state with history data');
          history = json.decode(response.body);
        });
      } else {
        print('Failed to fetch history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchHistory,
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return ListTile(
              title: Text(item['app_name']),
              subtitle: Text('${item['status']} at ${item['generated_at']}'),
            );
          },
        ),
      ),
    );
  }
}
