import 'dart:convert';
import 'package:http/http.dart' as http;
import 'history_data.dart';

class ApiService {
  static const String _baseUrl =
      'http://localhost:8000/api'; // Ganti dengan URL server Anda

  static Future<List<HistoryData>> fetchHistoryData() async {
    final response = await http.get(Uri.parse('$_baseUrl/integration-history'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => HistoryData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load history data');
    }
  }
}
