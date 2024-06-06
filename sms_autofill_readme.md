# Implementing SMS Autofill in a Flutter Project

## Introduction

This guide provides a detailed step-by-step process to integrate SMS autofill functionality in a Flutter project using the `flutter_sms_listener` and `permission_handler` packages.

## Packages Required

+ [flutter_sms_listener](https://pub.dev/packages/flutter_sms_listener)
+ [permission_handler](https://pub.dev/packages/permission_handler)

## Steps to Implement SMS Autofill

1. Add Dependencies

    Add the following dependencies to your `pubspec.yaml` file:

    ```
    dependencies:
      flutter:
        sdk: flutter
      flutter_sms_listener: ^0.1.0
      permission_handler: ^10.0.0
    ```
    Run `flutter pub get` to install packages.

2. Configure Android Permissions

    Modify the `AndroidManifest.xml` file to include the necessary permissions for reading SMS. Add the following lines within the `<manifest>` tag:

    ```
    <uses-permission android:name="android.permission.RECEIVE_SMS"/>
    <uses-permission android:name="android.permission.READ_SMS"/>
    ```

    The full path to the AndroidManifest.xml file in a typical Flutter project structure is:

    `your_flutter_project/android/app/src/main/AndroidManifest.xml`

3. Create the OTP Page 

    Create a new Dart file and implement the OTP page with SMS autofill functionality.

    3.1 Import Packages

      First, import the necessary packages:
      ```
      import 'package:flutter/material.dart';
      import 'package:flutter_sms_listener/flutter_sms_listener.dart';
      import 'package:permission_handler/permission_handler.dart';
      ```
    
    3.2 Create the OTPPage Widget

      Define the `OTPPage` widget and its state.

    3.3 checking **Permission Request** in the class:

      The `_checkPermissions` method checks if the app has SMS read permissions. If not, it requests the necessary permission using the `permission_handler` package.

      ```
      Future<void> _checkPermissions() async {
        PermissionStatus status = await Permission.sms.status;
        if (!status.isGranted) {
        await Permission.sms.request();
        }
      }
      ```
    
    3.4 **Listening for SMS** :

      The `_listenForSms` method uses the `flutter_sms_listener` package to listen for incoming SMS messages. When an SMS is received, it extracts the OTP and updates the text field.

      ```
      void _listenForSms() async {
        FlutterSmsListener smsListener = FlutterSmsListener();
        smsListener.onSmsReceived?.listen((SmsMessage? sms) {
          if (sms != null && sms.body != null) {
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
      ```

    3.5 **Extracting OTP** :

      The `_parseOTP` method uses a regular expression to extract a 6-digit OTP from the SMS message body.

      ```
      String _parseOTP(String messageBody) {
        RegExp regExp = RegExp(r'OTP Verification code : (\d{6})');
        Match? match = regExp.firstMatch(messageBody);
        return match?.group(1) ?? ''; // Group 1 contains the OTP
      }
      ```

      > [!NOTE]
      > the `messageBody` must match the specific format expected by the regular   expression in the `_parseOTP` method. The regular expression in the method is designed to look for a particular pattern, so the SMS message must conform to this pattern for the OTP to be successfully extracted.

    3.6 Build **UI** :
      
      Build UI, which includes a text field to display the OTP and a button to verify it.

4. Update the Main Application File

    Update the `main.dart` file to include the OTP page and handle navigation.

5. Test the Application

    Run the application on an Android emulator or physical device to test the SMS autofill functionality.

    ```
    flutter run
    ```


      