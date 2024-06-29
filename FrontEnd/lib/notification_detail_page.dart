import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDetailPage extends StatefulWidget {
  final int notificationId;

  NotificationDetailPage({required this.notificationId});

  @override
  _NotificationDetailPageState createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  late Future<NotificationDetail> _notificationDetail;

  @override
  void initState() {
    super.initState();
    _notificationDetail = fetchNotificationDetail(widget.notificationId);
  }

  Future<NotificationDetail> fetchNotificationDetail(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/notifications/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return NotificationDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load notification detail');
    }
  }

  void _handleResponse(String response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      _showErrorDialog(context, 'Error', 'Token not found');
      return;
    }

    try {
      final result = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/notification_response'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': widget.notificationId,
          'response': response,
        }),
      );

      if (result.statusCode == 200) {
        // Handle success
        Navigator.pop(context);
      } else if (result.statusCode == 302) {
        // Handle redirection
        _showErrorDialog(context, 'Error',
            'Failed to send response. Status code: 302 - Redirection detected');
      } else {
        // Handle other errors
        print('Response status: ${result.statusCode}');
        print('Response body: ${result.body}');
        _showErrorDialog(context, 'Error',
            'Failed to send response. Status code: ${result.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      _showErrorDialog(context, 'Error', 'An error occurred: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Detail'),
      ),
      body: FutureBuilder<NotificationDetail>(
        future: _notificationDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No notification detail available'));
          } else {
            NotificationDetail detail = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text(detail.body),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _handleResponse('yes');
                        },
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _handleResponse('no');
                        },
                        child: Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class NotificationDetail {
  final int id;
  final String title;
  final String body;

  NotificationDetail(
      {required this.id, required this.title, required this.body});

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
