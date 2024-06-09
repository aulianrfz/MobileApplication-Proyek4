import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_data.dart';

class ApiService {
  static Future<UserData?> fetchUserData() async {
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
        return UserData.fromJson(responseData);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } else {
      print('Token not found');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchFatherData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/fathers'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        return responseData;
      } else {
        print('Failed to fetch father data: ${response.statusCode}');
        return null;
      }
    } else {
      print('Token not found');
      return null;
    }
  }
}
