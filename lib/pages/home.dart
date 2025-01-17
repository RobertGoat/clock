import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  Timer? timer;
  bool isTimerRunning = false;
  bool isInitialized = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Initialize `data` only if it’s empty
  //   if (data.isEmpty) {
  //     // data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

  //     // print('Initial data: $data');

  //     if (data['time'] == null) {
  //       data['time'] = DateTime.now().toIso8601String();
  //     }
  //   }

  //   // Start a timer to update the time every minute
  //   startTimer();
  // }

  @override
  void didChangeDependencies() {
    // super.didChangeDependencies();

    // if (data.isEmpty) {
    //   final arguments = ModalRoute.of(context)!.settings.arguments;

    //   if (arguments is Map<String, dynamic>) {
    //     // Handle time and location details
    //     setState(() {
    //       data['time'] = arguments['time'] ?? DateTime.now().toIso8601String();
    //       data['location'] = arguments['location'] ?? 'Unknown';
    //       data['isDaytime'] = arguments['isDaytime'] ?? true;
    //     });
    //   } else if (arguments is List<String>) {
    //     // Handle list of time zones
    //     setState(() {
    //       data['timeZones'] = arguments; // Store list of time zones
    //     });
    //   } else {
    //     print('Error: Invalid arguments passed');
    //   }
    // }

    // startTimer();

    super.didChangeDependencies();
    print('Is initialized = $isInitialized');
    if (!isInitialized) {
      final arguments = ModalRoute.of(context)?.settings.arguments;

      if (arguments is Map<String, dynamic>) {
        setState(() {
          data['time'] = arguments['time'] ?? DateTime.now().toIso8601String();
          data['location'] = arguments['location'] ?? 'Unknown';
          data['isDaytime'] = arguments['isDaytime'] ?? true;
          data['offset'] = arguments['offset'] ?? Duration.zero;
        });

        // } else if (arguments is List<String>) {
        //   setState(() {
        //     data['timeZones'] = arguments;
        //   });
      } else {
        print('Invalid arguments passed to Home');
      }

      isInitialized = true; // Prevent re-initialization
    }

    print('Updated home screen data: $data');

    if (!isTimerRunning) {
      startTimer();
    }
  }

  void startTimer() {
    // // Cancel any existing timer before starting a new one
    // timer?.cancel();

    // // Start a new timer that runs every second
    // timer = Timer.periodic(const Duration(seconds: 1), (_) {
    //   updateTime();
    // });
    if (isTimerRunning)
      return; // Prevent starting a new timer if one is already running

    isTimerRunning = true; // Mark the timer as running
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel(); // Stop the timer if the widget is disposed
        return;
      }
      updateTime(); // Call your update function here
    });
  }

  void updateTime() {
    // setState(() {
    //   // Parse the current time, add 1 second, and update the data
    //   DateTime now = DateTime.parse(data['time']);
    //   now = now.add(const Duration(seconds: 1));
    //   data['time'] = now.toIso8601String(); // Store updated time in ISO format
    // });
    setState(() {
      try {
        DateTime currentTime = DateTime.now().toUtc(); // Get UTC time
        Duration offset = data['offset'] ?? Duration.zero; // Get offset
        DateTime adjustedTime = currentTime.add(offset); // Adjust time

        data['time'] = adjustedTime.toIso8601String();
        // Update time
        // print('Updated time: ${data['time']}'); // Debug: Updated time
      } catch (e) {
        print('Error updating time: $e');
      }
    });
  }
  // void updateTime() {
  //   setState(() {
  //     try {
  //       // Get the current system UTC time
  //       DateTime currentTime = DateTime.now().toUtc();

  //       // Retrieve the time zone offset from the data
  //       Duration offset = data['timeZoneOffset'];

  //       // Adjust the current time to the selected location's time zone
  //       DateTime adjustedTime = currentTime.add(offset);

  //       // Store the adjusted time in ISO format
  //       data['time'] = adjustedTime.toIso8601String();
  //     } catch (e) {
  //       print('Error updating time: $e');
  //     }
  //   });
  // }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTimeForZone(String timeZone) async {
    try {
      print('Fetching time for zone: $timeZone'); // Debug: Start fetching

      final response = await http.get(
        Uri.parse('https://timeapi.io/api/TimeZone/zone?timeZone=$timeZone'),
      );

      print(
          'API Response Status: ${response.statusCode}'); // Debug: Status code
      print('API Response Body: ${response.body}'); // Debug: Response body
      print('Data time = ${data['time']}');
      print('Data location = ${data['location']}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // setState(() {
        //   this.data['time'] =
        //       DateTime.parse(data['currentLocalTime']).toIso8601String();
        //   this.data['location'] = timeZone;
        //   this.data['isDaytime'] = data['isDayTime'];
        // });
        DateTime currentTime = DateTime.parse(data['currentLocalTime']);
        bool isDaytime = currentTime.hour >= 6 && currentTime.hour < 18;
        setState(() {
          data['time'] =
              DateTime.parse(data['currentLocalTime']).toIso8601String();
          data['location'] = timeZone;
          // this.data['isDaytime'] = data['isDaytime'];
          data['isDaytime'] = isDaytime;
          data['offset'] = Duration(
            hours: data['standardUtcOffset']['hours'] ?? 0,
            minutes: data['standardUtcOffset']['minutes'] ?? 0,
          );
        });
        print('setState in fetchfortimezone');
        print('Updated data: $data'); // Debug log
      } else {
        throw Exception('Failed to fetch time');
      }
    } catch (e) {
      print('Error fetching time for zone: $e');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   // Format the time for display
  //   String? formattedTime;

  //   try {
  //     // print('data[\'time\']: ${data['time']}');

  //     // formattedTime =
  //     //     DateTime.parse(data['time']).toLocal().toString().substring(11, 16);
  //     DateTime parsedTime = DateTime.parse(data['time']).toLocal();
  //     formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
  //   } catch (e) {
  //     // print('Invalid date format: $e');
  //     // print('formatted time = $formattedTime');
  //     formattedTime = 'Invalid Time';
  //   }
  //   // String formattedTime =
  //   //     DateTime.parse(data['time']).toLocal().toString().substring(11, 16);

  //   return Scaffold(
  //     backgroundColor: data['isDaytime'] ? Colors.blue : Colors.indigo[700],
  //     body: SafeArea(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             data['location'], // Display the location name
  //             style: const TextStyle(fontSize: 28, color: Colors.white),
  //           ),
  //           const SizedBox(height: 20),
  //           Text(
  //             formattedTime, // Display the updated time
  //             style: const TextStyle(fontSize: 64, color: Colors.white),
  //           ),
  //           // TextButton.icon(
  //           //   onPressed: () async {
  //           //     dynamic result =
  //           //         await Navigator.pushNamed(context, '/location');
  //           //     setState(() {
  //           //       data = {
  //           //         'time': result['time'],
  //           //         'location': result['location'],
  //           //         'isDaytime': result['isDaytime'],
  //           //         'flag': result['flag'],
  //           //       };
  //           //     });
  //           //   },
  //           //   icon: const Icon(Icons.edit_location, color: Colors.white),
  //           //   label: const Text(
  //           //     'Edit Location',
  //           //     style: TextStyle(color: Colors.white),
  //           //   ),
  //           // ),
  //           TextButton.icon(
  //             onPressed: () async {
  //               dynamic selectedZone =
  //                   await Navigator.pushNamed(context, '/location');
  //               if (selectedZone != null) {
  //                 // Fetch the time for the selected zone
  //                 await fetchTimeForZone(selectedZone);
  //               }
  //             },
  //             icon: const Icon(Icons.edit_location, color: Colors.white),
  //             label: const Text('Edit Location',
  //                 style: TextStyle(color: Colors.white)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // Check if the data contains a list of time zones
    // if (data.containsKey('timeZones')) {
    //   List<String> timeZones = data['timeZones'];

    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Choose a Location'),
    //       backgroundColor: Colors.blue[900],
    //     ),
    //     body: ListView.builder(
    //       itemCount: timeZones.length,
    //       itemBuilder: (context, index) {
    //         return ListTile(
    //           title: Text(timeZones[index]),
    //           onTap: () {
    //             Navigator.pop(
    //                 context, timeZones[index]); // Return selected zone
    //           },
    //         );
    //       },
    //     ),
    //   );
    // }

    // Otherwise, show the time and location
    String formattedTime = 'Invalid Time';

    if (data['time'] != null) {
      try {
        DateTime parsedTime = DateTime.parse(data['time']);
        formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
        // DateTime parsedTime = DateTime.parse(data['time']); // Keep it in UTC
        // Duration offset = data['offset'] ?? Duration.zero; // Offset for Berlin
        // DateTime adjustedTime = parsedTime.add(offset); // Apply the offset
        // formattedTime = DateFormat('HH:mm:ss').format(adjustedTime);

        // print('Data time (raw): ${data['time']}'); // Debugging
        // print('Parsed time (UTC): $parsedTime');
        // print('Adjusted time (Berlin): $adjustedTime');
        // print('Formatted time: $formattedTime');
      } catch (e) {
        print('Error parsing time: $e'); // Debugging
        formattedTime = 'Invalid Time';
      }
    }

    return Scaffold(
      // backgroundColor: data['isDaytime'] ? Colors.blue : Colors.indigo[700],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: data['isDaytime']
                ? [
                    const Color.fromARGB(255, 85, 152, 219),
                    const Color.fromARGB(255, 32, 42, 157)
                  ]
                : [Colors.indigo[700]!, const Color.fromARGB(255, 18, 18, 19)],
            // begin: Alignment.topCenter,
            // end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data['location'] ?? 'Unknown Location',
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  formattedTime ?? 'Invalid Time',
                  style: const TextStyle(fontSize: 64, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                TextButton.icon(
                  onPressed: () async {
                    dynamic selectedZone =
                        await Navigator.pushNamed(context, '/location');
                    print(
                        'Selected Zone: $selectedZone'); // Debug: Selected zone
                    print('Selected Zone Location: ${selectedZone['url']}');

                    if (selectedZone != null) {
                      setState(() {
                        data['location'] = selectedZone['location'];
                        // data['time'] = selectedZone['time'];
                        data['isDaytime'] = selectedZone['isDaytime'];
                        data['offset'] = selectedZone['offset'];
                        // data = selectedZone;
                      });
                      await fetchTimeForZone(selectedZone['url']);
                      setState(() {
                        data['time'] = selectedZone[
                            'time']; // Update with the fetched time
                      });

                      print('Home screen data updated: $data');
                    }
                  },
                  icon: const Icon(Icons.edit_location, color: Colors.white),
                  label: const Text('Edit Location',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
