import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sih/pages/Driver_homepage.dart';  // Ensure this import is correct

class DriverSignupPage extends StatefulWidget {
  const DriverSignupPage({super.key});

  @override
  _DriverSignupPageState createState() => _DriverSignupPageState();
}

class _DriverSignupPageState extends State<DriverSignupPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController badge = TextEditingController();
  final TextEditingController route = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool isOtpSent = false;
  bool _isLoading = false;

  void startTimer() {
    setState(() {
      isOtpSent = true;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _signupDriver() async {
    if (name.text.isEmpty ||
        badge.text.isEmpty ||
        route.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text != password.text) {
      _showError('Please fill all fields correctly.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Navigate to OTP screen after signup
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OTPScreen()),
    );
  }

  @override
  void dispose() {
    name.dispose();
    badge.dispose();
    route.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text("Driver Sign Up", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              _buildInputField(label: "Name", controller: name),
              _buildInputField(label: "PS Badge Number", controller: badge),
              _buildInputField(label: "Route No", controller: route),
              _buildInputField(label: "Email", controller: email),
              _buildPasswordInputField(label: "Password", controller: password),
              _buildPasswordInputField(label: "Confirm Password", controller: confirmPassword),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signupDriver,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildPasswordInputField({required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  bool isOtpValid = false;

  // Timer variables for OTP resend
  bool canResendOtp = false;
  int remainingTime = 300; // 5 minutes in seconds
  Timer? timer;

  String get formattedTime {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    otpController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      canResendOtp = false;
      remainingTime = 300;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  // Simulate OTP validation
  void validateOtp() {
    if (otpController.text == "123456") {
      setState(() {
        isOtpValid = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DelayFromDriverScreen(),
        ),
      );
    } else {
      _showError('Invalid OTP. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text("Enter OTP", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),
            const SizedBox(height: 20),
            Text(
              "Waiting for OTP... $formattedTime",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: validateOtp,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Verify OTP"),
            ),
            const SizedBox(height: 20),
            if (canResendOtp)
              GestureDetector(
                onTap: startTimer,
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
