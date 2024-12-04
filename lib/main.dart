import 'package:flutter/material.dart';
import 'routes.dart'; // Import routes file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bunch Free',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: AppRoutes.routes, // Define your routes in routes.dart
    );
  }
}
