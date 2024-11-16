import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sih/widgets/email_verification.dart';
import 'package:sih/widgets/passwordinputfield.dart';
import 'package:sih/user_home.dart';

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});

  @override
  _UserSignupPageState createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  // Controllers for input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userpasswordController = TextEditingController();
  final TextEditingController userconfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    usernameController.dispose();
    emailController.dispose();
    userpasswordController.dispose();
    userconfirmPasswordController.dispose();
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
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  'assets/animation1.json',
                  width: 250,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                inputFile(label: "Name", controller: usernameController),
                SizedBox(height: 20),
                inputFile(label: "Email", controller: emailController),
                SizedBox(height: 15),
                Align(
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
                SizedBox(height: 5),
                PasswordInputField(
                  label: "Password",
                  controller: userpasswordController,
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
                  controller: userconfirmPasswordController,
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

                // Email Verification Section
                VerifyEmailSection(),
                SizedBox(height: 30),

                // Submit Button
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserHomeScreen(),
                      ),
                    );
                  },
                  color: Color(0xff0095FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
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
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input field widget
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
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
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
}
