import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sih/widgets/email_verification.dart'; // Import the email verification widget
import 'package:sih/widgets/passwordinputfield.dart'; // Import the password input field widget
import 'package:sih/widgets/app_scrollbar.dart'; // Import the custom scrollbar widget

class DriverSignupPage extends StatefulWidget {
  const DriverSignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DriverSignupPageState createState() => _DriverSignupPageState();
}

class _DriverSignupPageState extends State<DriverSignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController badgeController = TextEditingController();
  final TextEditingController routeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    badgeController.dispose();
    routeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Driver Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AppScrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Lottie.asset(
                  'assets/animation1.json', // Animation asset
                  width: 250,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30),
                _buildInputField(label: "Name", controller: nameController),
                SizedBox(height: 15),
                _buildInputField(
                    label: "PS Badge Number", controller: badgeController),
                SizedBox(height: 15),
                _buildInputField(
                    label: "Route No", controller: routeController),
                SizedBox(height: 15),
                _buildInputField(label: "Email", controller: emailController),
                SizedBox(height: 15),
                PasswordInputField(
                  label: "Password",
                  controller: passwordController,
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
                SizedBox(height: 15),
                PasswordInputField(
                  label: "Confirm Password",
                  controller: confirmPasswordController,
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
                SizedBox(height: 30),
                VerifyEmailSection(),
                SizedBox(height: 30),
                _buildSubmitButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
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
      padding: EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signup Complete")),
          );
        },
        color: Color(0xff0095FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
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
