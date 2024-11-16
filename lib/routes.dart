import 'package:flutter/material.dart';
import 'widgets/header.dart'; // Ensure to import the Header widget

class FindRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(isDriver: false), // Using the header for non-driver users
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Heading for the screen
            Text(
              "Find a Route",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff0095FF)),
            ),
            SizedBox(height: 20),
            
            // Routes input section (Route 1 to Route 6)
            // Replaced for loop with List.generate for dynamic creation
            ...List.generate(6, (i) {
              return Column(
                children: [
                  Row(
                    children: [
                      // Route Input field
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Route ${i + 1}",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      
                      // View Button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the respective route's details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RouteDetailsScreen(routeNumber: i + 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0095FF),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "View",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Space between each route
                ],
              );
            }),

            // Image at the bottom (without Expanded widget)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/route.png"), // Replace with your image path
                    fit: BoxFit.cover,
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

// Route Details Screen (for viewing route details with dynamic location on the vertical line)
class RouteDetailsScreen extends StatefulWidget {
  final int routeNumber;

  RouteDetailsScreen({required this.routeNumber});

  @override
  _RouteDetailsScreenState createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _locationPosition = 0.0; // Represents the location of the bus on the line

  final List<String> stops = [
    "Start Point", "Stop 1", "Stop 2", "Stop 3", "Stop 4", "Stop 5", "Destination"
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 30), // Simulate bus moving
      vsync: this,
    )..repeat(reverse: true); // Move back and forth

    _controller.addListener(() {
      setState(() {
        _locationPosition = _controller.value * (stops.length - 1); // Normalize position
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details for Route ${widget.routeNumber}"),
        backgroundColor: Color(0xff0095FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Vertical line with moving location symbol
            Container(
              height: 300,
              child: Stack(
                children: [
                  // Road (Vertical line)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RoadPainter(stops.length),
                    ),
                  ),
                  // Moving location symbol
                  Positioned(
                    top: (300 / (stops.length - 1)) * _locationPosition,
                    left: 15,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  // Stop indicators
                  for (int i = 0; i < stops.length; i++) ...[
                    Positioned(
                      top: (300 / (stops.length - 1)) * i,
                      left: 40,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: i == 0 || i == stops.length - 1 ? Colors.green : Colors.grey,
                      ),
                    ),
                    Positioned(
                      top: (300 / (stops.length - 1)) * i - 10,
                      left: 60,
                      child: Text(
                        stops[i],
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display route details
            Text(
              "Route ${widget.routeNumber} has the following stops: ${stops.join(", ")}.",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter to draw the vertical line (road)
class RoadPainter extends CustomPainter {
  final int stopCount;

  RoadPainter(this.stopCount);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    // Draw vertical line (road)
    canvas.drawLine(Offset(20, 0), Offset(20, size.height), paint);

    // Draw intermediate stops (dots)
    for (int i = 0; i < stopCount; i++) {
      Paint dotPaint = Paint()
        ..color = i == 0 || i == stopCount - 1 ? Colors.green : Colors.grey
        ..style = PaintingStyle.fill;

      double yPosition = (size.height / (stopCount - 1)) * i;
      canvas.drawCircle(Offset(20, yPosition), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
