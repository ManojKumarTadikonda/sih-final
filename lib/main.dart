// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:sih/api/firebase_api.dart';
import 'routes.dart'; 

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotifications();
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
