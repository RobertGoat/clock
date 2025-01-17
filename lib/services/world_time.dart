import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; //location name for ui
  late String time; //time in that location
  String flag; //url to an asset flag icon
  String url; //location url for api end point
  late bool isDaytime;
  late Duration offset;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      //make the request
      final response = await http.get(
        Uri.parse('https://timeapi.io/api/TimeZone/zone?timeZone=$url'),
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        final data = jsonDecode(response.body);
        final datetime = data['currentLocalTime'];
        final offsetHours = data['currentUtcOffset']['hours'] ?? 0;
        final offsetSeconds = data['currentUtcOffset']['seconds'] ?? 0;

        // Store the offset as a Duration
        offset = Duration(seconds: offsetSeconds);
        DateTime now = DateTime.parse(datetime);

        // DateTime now = DateTime.now();
        // data['time'] = now();

        // Determine if it's daytime
        isDaytime = now.hour > 6 && now.hour < 20;
        // print('World-time isDaytime: ${isDaytime}');
        // Format the time for display
        // time = DateFormat.jm().format(now);
        time = now.toIso8601String();
      } else {
        // Handle non-200 responses
        throw Exception(
            'Failed to fetch time. Status code: ${response.statusCode}');
      }
      // print(data);

      // print(datetime);
      // print(offset);
    } catch (e) {
      // Handle any errors
      print('Error fetching time: $e');
      isDaytime = true; // Fallback to daytime
      time = 'Unavailable'; // Fallback time
    }
  }
}
