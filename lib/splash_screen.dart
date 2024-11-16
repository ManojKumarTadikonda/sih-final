import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:sih/pages/Homepage.dart'; // Import the HomePages screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePages(isDriver: false),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set your splash screen background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the first Lottie animation
            Lottie.asset(
              'assets/Animation.json', // Replace with the path to your animation file
              height: 300, // Adjust height as needed
            ),
            SizedBox(height: 20),
            // Display the second Lottie animation
            Lottie.asset(
              'assets/animation2.json', // Replace with the path to your animation file
              height: 300, // Adjust height as needed
            ),
          ],
        ),
      ),
    );
  }
}
