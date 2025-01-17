import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeService {
  static Future<Map<String, dynamic>> fetchTime(String url) async {
    try {
      final response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'time': data['datetime'],
          'isDaytime': data['datetime'].contains('T'),
        };
      } else {
        throw Exception('Failed to load time data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
