import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_time/services/world_time.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  bool isLoading = false;
  // int counter = 0;
  List<WorldTime> locations = [
    // WorldTime(url: 'Europe/London', location: 'London', flag: 'uk .png'),
    // WorldTime(url: 'Europe/Athens', location: 'Athens', flag: 'greece.png'),
    // WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'egypt.png'),
    // WorldTime(url: 'Africa/Nairobi', location: 'Nairobi', flag: 'kenya.png'),
    // WorldTime(url: 'America/Chicago', location: 'Chicago', flag: 'usa.png'),
    // WorldTime(url: 'America/New_York', location: 'New York', flag: 'usa.png'),
    // WorldTime(url: 'Asia/Seoul', location: 'Seoul', flag: 'south_korea.png'),
    WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', flag: 'id.png'),
    WorldTime(url: 'Europe/Paris', location: 'Paris', flag: 'fr.png'),
    WorldTime(url: 'Europe/Rome', location: 'Rome', flag: 'it.png'),
    WorldTime(url: 'Asia/Seoul', location: 'Seoul', flag: 'kr.png'),
    WorldTime(
        url: 'America/Los_Angeles', location: 'Los Angeles', flag: 'us.png'),
    WorldTime(url: 'Africa/Nairobi', location: 'Nairobi', flag: 'ke.png'),
    WorldTime(
        url: 'Africa/Johannesburg', location: 'Johannesburg', flag: 'za.png'),
    WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'eg.png'),
    WorldTime(url: 'Asia/Shanghai', location: 'Shanghai', flag: 'cn.png'),
    WorldTime(url: 'Australia/Sydney', location: 'Sydney', flag: 'au.png'),
    WorldTime(url: 'America/New_York', location: 'New York', flag: 'us.png'),
    WorldTime(
        url: 'America/Mexico_City', location: 'Mexico City', flag: 'mx.png'),
    WorldTime(url: 'America/Chicago', location: 'Chicago', flag: 'us.png'),
    WorldTime(url: 'Asia/Tokyo', location: 'Tokyo', flag: 'jp.png'),
    WorldTime(url: 'Asia/Kolkata', location: 'New Delhi', flag: 'in.png'),
    WorldTime(
        url: 'Australia/Melbourne', location: 'Melbourne', flag: 'au.png'),
    WorldTime(
        url: 'America/Argentina/Buenos_Aires',
        location: 'Buenos Aires',
        flag: 'ar.png'),
    WorldTime(url: 'Europe/London', location: 'London', flag: 'gb.png'),
    WorldTime(url: 'Asia/Dubai', location: 'Dubai', flag: 'ae.png'),
  ];

  // List<String> timeZones = []; // Holds the list of time zones
  // bool isLoading = true; // Indicates if data is still loading

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchTimeZones();
  }

  // Future<void> fetchTimeZones() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://timeapi.io/api/TimeZone/AvailableTimeZones'),
  //     );

  //     if (response.statusCode == 200) {
  //       // Parse the response JSON
  //       List<String> zones = List<String>.from(jsonDecode(response.body));
  //       setState(() {
  //         timeZones = zones;
  //         print(timeZones);
  //         isLoading = false; // Data is loaded
  //       });
  //     } else {
  //       throw Exception('Failed to fetch time zones');
  //     }
  //   } catch (e) {
  //     print('Error fetching time zones: $e');
  //     setState(() {
  //       isLoading = false; // Stop loading on error
  //     });
  //   }
  // }

  void updateTime(index) async {
    setState(() {
      isLoading = true;
    });

    WorldTime instance = locations[index];
    print('instance = $instance');
    await instance.getTime();

    //navigate to home screen
    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDaytime': instance.isDaytime,
      'url': instance.url,
      'offset': instance.offset,
    });

    setState(() {
      isLoading = false;
    });

    print('POP Location: ${instance.location}');
    print('POP Flag: ${instance.flag}');
    print('POP Time: ${instance.time}');
    print('POP isDaytime: ${instance.isDaytime}');
    print('POP URL: ${instance.url}');
    print('POP offset: ${instance.offset}');
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Choose Location'),
  //       backgroundColor: Colors.blue[900],
  //       centerTitle: true,
  //       elevation: 0,
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : ListView.builder(
  //             itemCount: timeZones.length,
  //             itemBuilder: (context, index) {
  //               return Card(
  //                 child: ListTile(
  //                   title: Text(timeZones[index]),
  //                   onTap: () {
  //                     Navigator.pop(context, timeZones[index]);
  //                   },
  //                 ),
  //               );
  //             },
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // print('Build function ran2');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isLoading
          ? null
          : AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: Color.fromARGB(255, 41, 54, 163),
              title: const Text(
                'Choose a location',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
      body: isLoading
          ? const Scaffold(
              backgroundColor: Color.fromARGB(255, 41, 54, 163),
              body: Center(
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 80.0,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8), // Add vertical padding for top and bottom

              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey, // Set the border color here
                        width: 2, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(
                          15), // Match the Card border radius
                    ),
                    child: Card(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(8),

                      // ),
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          updateTime(index);
                        },
                        title: Text(
                          locations[index].location,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        leading: Container(
                          width: 50, // Adjust size as needed
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueGrey, // Border color
                              width: 2, // Border width
                            ),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/${locations[index].flag}'),
                              fit: BoxFit
                                  .cover, // Ensure the flag fits the circle properly
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: locations.length,
            ),
    );
  }
}
