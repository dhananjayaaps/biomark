import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'otp_validate_page.dart';
import 'securityquiz_page.dart';
import 'settings_page.dart';
import 'welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initially set the theme mode to light
  bool isDarkMode = false;

  // Function to toggle the theme mode
  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/settings': (context) => SettingsPage(),
        '/login': (context) => LoginPage(),  // Default route
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(toggleTheme),
        '/otpvalidate': (context) => OTPValidationPage(),
        '/securityquiz': (context) => SecurityQuestionsSetupPage(),
      },
    );
  }
}