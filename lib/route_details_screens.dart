import 'package:flutter/material.dart';

class RouteDetailsScreen extends StatefulWidget {
  final List<String> routeNames; // Names of stops (e.g., Start, Intermediate Stops, Destination)
  const RouteDetailsScreen({Key? key, required this.routeNames}) : super(key: key);

  @override
  _RouteDetailsScreenState createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  double currentLocation = 0.0; // Initial location (Start)
  late List<Offset> stopPositions; // Positions of the stops along the vertical line

  @override
  void initState() {
    super.initState();
    stopPositions = _generateStopPositions();
  }

  // Function to generate stop positions based on the number of stops
  List<Offset> _generateStopPositions() {
    double step = 1.0 / widget.routeNames.length; // Calculate step size between stops
    return List.generate(
      widget.routeNames.length,
      (index) => Offset(0.0, step * index),
    );
  }

  // Function to simulate the bus moving along the route
  void moveBus() {
    Future.delayed(Duration(seconds: 2), () {
      if (currentLocation < 1.0) {
        setState(() {
          currentLocation += 0.1; // Increment the location
        });
        moveBus(); // Keep moving the bus
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route Details"),
        backgroundColor: Color(0xff0095FF),
      ),
      body: Stack(
        children: [
          // Vertical Line representing the route
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 3,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[400],
              ),
            ),
          ),

          // Dots representing stops
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.routeNames.length,
                  (index) => Positioned(
                    top: MediaQuery.of(context).size.height * stopPositions[index].dy,
                    child: Row(
                      children: [
                        // Stop Dot
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(widget.routeNames[index]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Location Marker
          Positioned(
            top: MediaQuery.of(context).size.height * currentLocation,
            left: 50, // Slightly offset for better visibility
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 30,
            ),
          ),

          // Start Simulation Button (Optional)
          Positioned(
            bottom: 30,
            left: 30,
            child: ElevatedButton(
              onPressed: moveBus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0095FF),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Start Route",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
