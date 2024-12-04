import 'dart:async';
import 'package:flutter/material.dart';

class VerifyEmailSection extends StatefulWidget {
  const VerifyEmailSection({super.key});

  @override
  _VerifyEmailSectionState createState() => _VerifyEmailSectionState();
}

class _VerifyEmailSectionState extends State<VerifyEmailSection> {
  bool isOtpSent = false;
  bool canResendOtp = false;
  int remainingTime = 300; // 5 minutes in seconds
  Timer? timer;
  final TextEditingController otpController = TextEditingController();

  void startTimer() {
    setState(() {
      isOtpSent = true;
      canResendOtp = false;
      remainingTime = 300; // Reset the timer to 5 minutes
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer on widget dispose
    otpController.dispose();
    super.dispose();
  }

  String get formattedTime {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isOtpSent ? null : startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0095FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
          child: Text(
            isOtpSent ? "OTP Sent" : "Verify Email",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        if (isOtpSent) ...[
          SizedBox(height: 20),
          TextFormField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter OTP",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Waiting for OTP... $formattedTime",
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 10),
          if (canResendOtp) ...[
            Text(
              "Couldn't get OTP?",
              style: TextStyle(color: Colors.grey[700]),
            ),
            GestureDetector(
              onTap: startTimer,
              child: Text(
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
      ],
    );
  }
}
