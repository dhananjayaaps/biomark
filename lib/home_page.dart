import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current theme mode (light or dark)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.purple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sineth Dhananjaya',
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
            // Profile Button
            ListTile(
              leading: Icon(Icons.person, color: isDarkMode ? Colors.white : Colors.purple),
              title: Text('Profile', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            // Settings Button
            ListTile(
              leading: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.purple),
              title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            // Logout Button
            ListTile(
              leading: Icon(Icons.logout, color: isDarkMode ? Colors.white : Colors.purple),
              title: Text('Logout', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                // Add logout logic here
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
