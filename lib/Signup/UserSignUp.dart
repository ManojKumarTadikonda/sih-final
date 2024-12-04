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
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add a GlobalKey for form validation

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
      body: AppScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
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
                  SizedBox(height: 20),
                  inputFile(label: "Name", controller: username),
                  SizedBox(height: 20),
                  inputFile(label: "Email", controller: useremail),
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
                  SizedBox(height: 15),
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
                  SizedBox(height: 15),

                  // Email Verification Section
                  VerifyEmailSection(),
                  SizedBox(height: 30),

                  // Submit Button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserHomeScreen(),
                          ),
                        );
                      }
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
          style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        TextFormField(
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
