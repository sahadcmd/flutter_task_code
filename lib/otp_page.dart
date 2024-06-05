import 'package:flutter/material.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildOTPVerification(),
      ),
    );
  }

  Widget _buildOTPVerification() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'OTP',
              hintText: 'Enter OTP',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter OTP';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _verifyOTP,
            child: const Text('Verify OTP'),
          ),
        ],
      ),
    );
  }

  void _verifyOTP() {
    if (_formKey.currentState!.validate()) {
      // Perform OTP verification here
      // Add your OTP verification logic here
    }
  }
}
