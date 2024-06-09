import 'package:flutter/material.dart';
import 'api_service.dart';
import 'notification_data.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationData>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = ApiService.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<NotificationData>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Memeriksa apakah ada notifikasi
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final notification = snapshot.data![index];
                  return ListTile(
                    title: Text(notification.message),
                    // Tambahkan logika yang diperlukan di sini
                  );
                },
              );
            } else {
              // Jika tidak ada notifikasi, tampilkan notifikasi default
              return Center(child: Text('No notifications'));
            }
          }
        },
      ),
    );
  }
}
