// verification_page.dart
import 'package:flutter/material.dart';
import 'dart:async';

class VerificationPage extends StatefulWidget {
  final VoidCallback onOtpVerified; // Callback when OTP is verified

  const VerificationPage({required this.onOtpVerified, Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController otpController = TextEditingController();
  late Timer _timer;
  int _start = 60; // 60 seconds countdown

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          timer.cancel();
          // Optionally, resend OTP or disable submission when time runs out
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  void submitOtp() {
    // Implement OTP verification logic here
    widget.onOtpVerified();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter OTP",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "OTP",
              ),
            ),
            SizedBox(height: 20),
            Text("Time remaining: $_start seconds"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitOtp,
              child: Text("Submit OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
