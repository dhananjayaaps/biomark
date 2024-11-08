// import 'package:flutter/material.dart';
// import 'login_page.dart';
// import 'signup_page.dart';
// import 'home_page.dart';
// import 'otp_validate_page.dart';
// import 'securityquiz_page.dart';
// import 'settings_page.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       // Define initial route and named routes
//       initialRoute: '/home',
//       routes: {
//         '/login': (context) => LoginPage(),  // Default route
//         '/signup': (context) => SignUpPage(),
//         '/home': (context) => HomePage(),
//         '/otpvalidate': (context) => OTPValidationPage(),
//         '/securityquiz': (context) => SecurityQuestionsSetupPage(),
//         '/settings': (context) => SettingsPage(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'otp_validate_page.dart';
import 'securityquiz_page.dart';
import 'settings_page.dart';

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
      initialRoute: '/signup',
      routes: {
        '/': (context) => HomePage(toggleTheme),
        '/settings': (context) => SettingsPage(toggleTheme, isDarkMode),
        '/login': (context) => LoginPage(),  // Default route
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(toggleTheme),
        '/otpvalidate': (context) => OTPValidationPage(),
        '/securityquiz': (context) => SecurityQuestionsSetupPage(),
        // '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(bool) toggleTheme;
  HomePage(this.toggleTheme);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Name',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'your.email@example.com',
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.white54),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: isDarkMode ? Colors.white : Colors.purple),
              title: Text('Profile', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.purple),
              title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: isDarkMode ? Colors.white : Colors.purple),
              title: Text('Logout', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool currentTheme;

  SettingsPage(this.toggleTheme, this.currentTheme);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.currentTheme; // Initialize with the current theme state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.purple,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(
              'Dark Mode',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
              widget.toggleTheme(isDarkMode); // Notify MyApp to update the theme globally
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: isDarkMode ? Colors.white : Colors.purple),
            title: Text(
              'Delete All Data',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            onTap: () {
              // Add your data clearing logic here
            },
          ),
        ],
      ),
    );
  }
}
