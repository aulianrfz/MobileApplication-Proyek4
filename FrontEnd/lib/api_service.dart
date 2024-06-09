import 'dart:convert';
import 'package:http/http.dart' as http;
import 'history_data.dart';
import 'shared_prefences.dart';
import 'notification_data.dart'; // Import untuk mengambil user_id dari shared preferences

class ApiService {
  static const String _baseUrl =
      'http://localhost:8000/api'; // Ganti dengan URL server Anda

  static Future<List<HistoryData>> fetchHistoryData() async {
    final userData = await SharedPreferencesManager.getUserData();
    final userId = userData['user_id'];

    final response = await http
        .get(Uri.parse('$_baseUrl/integration-history?user_id=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => HistoryData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load history data');
    }
  }

  static Future<List<NotificationData>> fetchNotifications() async {
    final userData = await SharedPreferencesManager.getUserData();
    final userId = userData['user_id'];

    final response =
        await http.get(Uri.parse('$_baseUrl/notifications?user_id=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Periksa jika data tidak null sebelum melakukan pemetaan ke NotificationData
      if (data != null) {
        return data.map((json) => NotificationData.fromJson(json)).toList();
      } else {
        // Jika data null, kembalikan notifikasi default
        return [NotificationData(message: 'terdapat akses login')];
      }
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  static Future<void> markNotificationAsRead(int id) async {
    final response =
        await http.post(Uri.parse('$_baseUrl/notifications/$id/mark-as-read'));

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }
}
