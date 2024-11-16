import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'widgets/header.dart'; // Ensure to import the Header widget

// Define a Bus Schedule model to represent the data structure with stops.
class BusSchedule {
  final String busNumber;
  final String source;
  final String destination;
  final List<Stop> stops; // List of stops

  BusSchedule({required this.busNumber, required this.source, required this.destination, required this.stops});

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    var list = json['stops'] as List;
    List<Stop> stopsList = list.map((i) => Stop.fromJson(i)).toList();

    return BusSchedule(
      busNumber: json['bus_number'],
      source: json['source'],
      destination: json['destination'],
      stops: stopsList,
    );
  }
}

class Stop {
  final String name;
  final double lat;
  final double lng;

  Stop({required this.name, required this.lat, required this.lng});

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      name: json['name'],
      lat: json['coordinates']['lat'],
      lng: json['coordinates']['lng'],
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<BusSchedule> busSchedules = [];
  List<BusSchedule> filteredBuses = [];

  String fromLocation = '';
  String toLocation = '';

  @override
  void initState() {
    super.initState();
    loadBusSchedules();
  }

  // Load bus schedule data from the JSON file.
  Future<void> loadBusSchedules() async {
    final String response = await rootBundle.loadString('assets/dtc.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      busSchedules = data.map((item) => BusSchedule.fromJson(item)).toList();
      filteredBuses = busSchedules;
    });
  }

  // Filter buses based on the "From" and "To" locations.
  void filterBuses() {
    setState(() {
      filteredBuses = busSchedules.where((bus) {
        final matchesFrom = bus.source.toLowerCase().contains(fromLocation.toLowerCase());
        final matchesTo = bus.destination.toLowerCase().contains(toLocation.toLowerCase());
        return matchesFrom && matchesTo;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(isDriver: false), // Header for user
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // From and To location input fields
            TextField(
              decoration: InputDecoration(labelText: 'From'),
              onChanged: (value) {
                setState(() {
                  fromLocation = value;
                });
                filterBuses();
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'To'),
              onChanged: (value) {
                setState(() {
                  toLocation = value;
                });
                filterBuses();
              },
            ),
            SizedBox(height: 20),
            
            // Report Delay button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user_report');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0095FF),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Report Delay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Check if filteredBuses is empty, and show animation if no results found
            filteredBuses.isEmpty
                ? Expanded(
                    child: Center(
                      child: Lottie.asset(
                        'assets/404notfound.json', // Path to your animation file
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Expanded(
                    child: Scrollbar(
                      thumbVisibility: true, // Always show the scrollbar thumb for better visibility
                      thickness: 6, // Customize thickness of the scrollbar
                      radius: Radius.circular(8), // Rounded corners for the scrollbar
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            // Table headers
                            Row(
                              children: [
                                Expanded(child: Text('Bus Number', style: TextStyle(fontWeight: FontWeight.bold))),
                                VerticalDivider(thickness: 1, color: Colors.grey),
                                Expanded(child: Text('Source', style: TextStyle(fontWeight: FontWeight.bold))),
                                VerticalDivider(thickness: 1, color: Colors.grey),
                                Expanded(child: Text('Destination', style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                            ),
                            Divider(thickness: 1, color: Colors.grey),
                            // Table data rows
                            ...filteredBuses.map((bus) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Navigate to another page to show detailed stops for the bus
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BusDetailsPage(bus: bus),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(bus.busNumber)),
                                        VerticalDivider(thickness: 1, color: Colors.grey),
                                        Expanded(child: Text(bus.source)),
                                        VerticalDivider(thickness: 1, color: Colors.grey),
                                        Expanded(child: Text(bus.destination)),
                                      ],
                                    ),
                                  ),
                                  Divider(thickness: 1, color: Colors.grey),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Create a new page to display the bus details (list of stops)
class BusDetailsPage extends StatelessWidget {
  final BusSchedule bus;

  BusDetailsPage({required this.bus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bus Details - ${bus.busNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          children: [
            Text('Source: ${bus.source}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Destination: ${bus.destination}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bus.stops.length,
                itemBuilder: (context, index) {
                  final stop = bus.stops[index];
                  return ListTile(
                    title: Text(stop.name),
                    subtitle: Text('Lat: ${stop.lat}, Lng: ${stop.lng}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
