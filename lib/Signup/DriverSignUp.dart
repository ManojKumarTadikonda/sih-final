import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:sih/pages/driver_homepage.dart';
import 'package:sih/widgets/passwordinputfield.dart'; // Import the password input field widget
import 'package:sih/widgets/app_scrollbar.dart'; // Import the custom scrollbar widget

class DriverSignupPage extends StatefulWidget {
  const DriverSignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DriverSignupPageState createState() => _DriverSignupPageState();
}

class _DriverSignupPageState extends State<DriverSignupPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController badge = TextEditingController();
  final TextEditingController route = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isOtpSent = false;
  bool canResendOtp = false;
  int remainingTime = 300; // 5 minutes in seconds
  Timer? timer;

  String get formattedTime {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _signupDriver() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Debugging: Log input values for visibility during signup
    print(
        'Attempting signup with Name: ${name.text.trim()}, Email: ${email.text.trim()}');

    const String apiUrl = 'http://10.0.2.2:8000/api/signup/driver';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'psbBadge': badge.text.trim(),
          'routeNumber': route.text.trim(),
          'password': password.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('User signup successful: $data');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DelayFromDriverScreen(),
          ),
        );
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        print('Signup failed with error: ${errorData['error']}');
        _showError(errorData['error'] ?? 'Invalid credentials');
      } else {
        print('Unexpected response: ${response.body}');
        _showError('Signup failed. Please try again later.');
      }
    } catch (error) {
      print('Error occurred during signup: $error');
      _showError('An error occurred. Please check your connection.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void startTimer() {
    setState(() {
      isOtpSent = true;
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
  void dispose() {
    name.dispose();
    badge.dispose();
    route.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    otpController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Driver Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AppScrollbar(
        thumbVisibility: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Lottie.asset(
                  'assets/animation1.json',
                  width: 250,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                _buildInputField(label: "Name", controller: name),
                const SizedBox(height: 15),
                _buildInputField(label: "PS Badge Number", controller: badge),
                const SizedBox(height: 15),
                _buildInputField(label: "Route No", controller: route),
                const SizedBox(height: 15),
                _buildInputField(label: "Email", controller: email),
                const SizedBox(height: 15),
                PasswordInputField(
                  label: "Password",
                  controller: password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                PasswordInputField(
                  label: "Confirm Password",
                  controller: confirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (name.text.isNotEmpty &&
                        badge.text.isNotEmpty &&
                        route.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        password.text.isNotEmpty &&
                        confirmPassword.text == password.text) {
                      startTimer();
                    } else {
                      _showError('Fill all fields correctly to verify email.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0095FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: Text(
                    isOtpSent ? "OTP Sent" : "Verify Email",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isOtpSent) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Waiting for OTP... $formattedTime",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  if (canResendOtp) ...[
                    Text(
                      "Couldn't get OTP?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: startTimer,
                      child: const Text(
                        "Resend",
                        style: TextStyle(
                          color: Color(0xff0095FF),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 30),
                _buildSubmitButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        color: const Color(0xff0095FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        //onPressed: _signupDriver,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DelayFromDriverScreen(),
            ),
          ),
        },
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Signup",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
