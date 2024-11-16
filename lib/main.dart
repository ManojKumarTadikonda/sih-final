import 'package:flutter/material.dart';
import 'package:sih/pages/Driver_homepage.dart';
import 'package:sih/Signup/DriverSignUp.dart';
import 'package:sih/Signup/MainSignUp.dart';
import 'package:sih/Signup/UserSignUp.dart';
import 'package:sih/pages/driver_notifications_page.dart';
import 'package:sih/pages/loginpage.dart';
import 'package:sih/user_home.dart';
import 'package:sih/widgets/editprofile.dart';
import 'package:sih/widgets/profile.dart';
import 'package:sih/routes.dart';
import 'package:sih/pages/user_reportpage.dart';
import 'package:sih/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial screen
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/profile':(context) => ProfileScreen(),
        '/edit':(context)=>EditProfileScreen(),
        '/driver_signup': (context) => DriverSignupPage(),
        '/user_signup': (context) => UserSignupPage(),
        '/driver_notifications': (context) => DriverNotificationScreen(),
        '/driver_delay': (context) => DelayFromDriverScreen(),
        '/user_home': (context) => UserHomeScreen(),
        '/user_report': (context) => UserReportFormScreen(),
        '/user_routes': (context) => FindRouteScreen(),
        '/driver_home':(context) => DelayFromDriverScreen(),
      },
    );
  }
}

