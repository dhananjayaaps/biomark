import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'otp_validate_page.dart';
import 'securityquiz_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // Define initial route and named routes
      initialRoute: '/securityquiz',
      routes: {
        '/login': (context) => LoginPage(),  // Default route
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/otpvalidate': (context) => OTPValidationPage(),
        '/securityquiz': (context) => SecurityQuestionsSetupPage(),
      },
    );
  }
}
