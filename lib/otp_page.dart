import 'package:flutter/material.dart';

class OTPPage extends StatelessWidget {
  const OTPPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Page'),
      ),
      body: const Center(
        child: Text('This is the OTP Page'),
      ),
    );
  }
}
