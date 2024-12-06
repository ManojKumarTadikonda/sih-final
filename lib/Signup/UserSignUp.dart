import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sih/pages/user_homepage.dart';
import 'package:sih/widgets/email_verification.dart';
import 'package:sih/widgets/passwordinputfield.dart';
import 'package:sih/widgets/app_scrollbar.dart';

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});

  @override
  _UserSignupPageState createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  // Controllers for input fields
  final TextEditingController username = TextEditingController();
  final TextEditingController useremail = TextEditingController();
  final TextEditingController userpassword = TextEditingController();
  final TextEditingController userconfirmPassword = TextEditingController();
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a GlobalKey for form validation
  Future<void> _signupUser() async {
    // Validate the form before proceeding
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if the form is invalid
    }

    // Debugging: Log input values for visibility during signup
    print(
        'Attempting signup with Name: ${username.text.trim()}, Email: ${useremail.text.trim()}');

    setState(() {
      _isLoading = true; // Indicate loading state
    });

    // Define your API endpoint
    const String apiUrl = 'http://10.0.2.2:8000/api/signup/user';

    try {
      // Send a POST request to the server
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Specify JSON content type
        },
        body: jsonEncode({
          'name': username.text.trim(),
          'email': useremail.text.trim(),
          'password': userpassword.text.trim(),
        }),
      );

      // Handle the response based on the status code
      if (response.statusCode == 201) {
        // Parse and log success data

        final data = jsonDecode(response.body);
        print('User signup successful: $data');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserHomeScreen(),
          ),
        ); // Navigate to user home screen
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        // Parse and display the error message
        final errorData = jsonDecode(response.body);
        print('Signup failed with error: ${errorData['error']}');
        _showError(errorData['error'] ?? 'Invalid credentials');
      } else {
        // Handle unexpected response
        print('Unexpected response: ${response.body}');
        _showError('Signup failed. Please try again later.');
      }
    } catch (error) {
      // Handle and log errors
      print('Error occurred during signup: $error');
      _showError('An error occurred. Please check your connection.');
    } finally {
      // Ensure loading state is reset
      setState(() {
        _isLoading = false;
      });
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
  void dispose() {
    // Dispose controllers to free up resources
    username.dispose();
    useremail.dispose();
    userpassword.dispose();
    userconfirmPassword.dispose();
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/headerlogo.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: AppScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey, // Wrap the form fields in a Form widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    'assets/animation1.json',
                    width: 250,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  inputFile(label: "Name", controller: username),
                  const SizedBox(height: 20),
                  inputFile(label: "Email", controller: useremail),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create a Password",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  PasswordInputField(
                    label: "Password",
                    controller: userpassword,
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
                    controller: userconfirmPassword,
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

                  // Email Verification Section
                  const VerifyEmailSection(),
                  const SizedBox(height: 30),

                  // Submit Button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    // onPressed: _isLoading
                    //     ? null
                    //     : () {
                    //         _signupUser();
                    //       },
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserHomeScreen(),
                        ),
                      ),
                    },
                    color: const Color(0xff0095FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Input field widget with TextFormField
  Widget inputFile({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
