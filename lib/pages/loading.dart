import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String time = 'loading';
  List<String> timeZones = [];

  void setupWorldTime({Map? arguments}) async {
    // WorldTime instance = WorldTime(
    //     location: 'Berlin', flag: 'germany.png', url: 'Europe/Berlin');

    // await instance.getTime();
    // Navigator.pushReplacementNamed(context, '/home', arguments: {
    //   'location': instance.location,
    //   'flag': instance.flag,
    //   'time': instance.time,
    //   'isDaytime': instance.isDaytime,
    // });

    // print(instance.time);
    // setState(() {
    //   time = instance.time;
    // });

    WorldTime instance = arguments != null
        ? WorldTime(
            location: arguments['location'],
            flag: arguments['flag'],
            url: arguments['url'],
          )
        : WorldTime(
            location: 'Jakarta',
            flag: 'indonesia.png',
            url: 'Asia/Jakarta',
          );

    await instance.getTime();
    // print("Hi im in loading.dart");
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDaytime': instance.isDaytime,
      'offset': instance.offset,
    });
  }
  // void fetchTimeZones() async {
  //   try {
  //     // Fetch the available time zones from the API
  //     final response = await http.get(
  //       Uri.parse('https://timeapi.io/api/TimeZone/AvailableTimeZones'),

  //       // Uri.parse('http://worldtimeapi.org/api/timezone'),
  //     );
  //     // print('API Response: ${response.body}');

  //     if (response.statusCode == 200) {
  //       List<String> zones = List<String>.from(jsonDecode(response.body));

  //       // Navigate to the Home screen and pass the list of time zones
  //       Navigator.pushReplacementNamed(context, '/home', arguments: {
  //         'timeZones': zones, // Pass the full list of time zones
  //       });
  //     } else {
  //       throw Exception('Failed to load time zones');
  //     }
  //   } catch (e) {
  //     print('Error fetching time zones: $e');

  //     // Fallback on error
  //     Navigator.pushReplacementNamed(context, '/home', arguments: {
  //       'timeZones': [], // Pass an empty list in case of failure
  //     });
  //   }
  // }

//   Future<void> fetchTimeForZone(String timeZone) async {
//   setState(() {
//     this.da['isLoading'] = true; // Add a loading flag
//   });

//   try {
//     final response = await http.get(
//       Uri.parse('https://timeapi.io/api/TimeZone/zone?timeZone=$timeZone'),
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       setState(() {
//         data['time'] = DateTime.parse(responseData['currentLocalTime']).toIso8601String();
//         data['location'] = timeZone;
//         data['isDaytime'] = responseData['isDayTime'];
//         data['isLoading'] = false;
//       });
//     } else {
//       throw Exception('Failed to fetch time');
//     }
//   } catch (e) {
//     print('Error fetching time for zone: $e');
//     setState(() {
//       data['isLoading'] = false;
//     });
//   }
// }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
      setupWorldTime(arguments: arguments);
    }); // fetchTimeZone();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 54, 163),
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
