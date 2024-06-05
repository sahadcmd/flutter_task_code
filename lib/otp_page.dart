import 'package:flutter/material.dart';
import 'package:flutter_sms_listener/flutter_sms_listener.dart';
import 'package:permission_handler/permission_handler.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Check permissions when the OTPPage initializes
    _listenForSms();
  }

  Future<void> _checkPermissions() async {
    PermissionStatus status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _listenForSms() async {
    FlutterSmsListener smsListener = FlutterSmsListener();
    smsListener.onSmsReceived?.listen((SmsMessage? sms) {
      if (sms != null && sms.body != null) {
        // Extract OTP from the received message
        String otp = _parseOTP(sms.body!);
        if (otp.isNotEmpty) {
          setState(() {
            _otpController.text = otp;
          });
        }
      }
    });
    smsListener.startListening;
  }

  String _parseOTP(String messageBody) {
    // Implement your OTP extraction logic here
    RegExp regExp = RegExp(r'OTP Verification code : (\d{6})');
    Match? match = regExp.firstMatch(messageBody);
    return match?.group(1) ?? ''; // Group 1 contains the OTP
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your OTP verification logic here
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on FlutterSmsListener {
  get startListening => null;
}
