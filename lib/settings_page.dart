import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  void _deleteAllData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Data'),
          content: Text('Are you sure you want to delete all data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your data clearing logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All data deleted')));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode (light or dark)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
              // Change theme
              if (isDarkMode) {
                Theme.of(context).copyWith(brightness: Brightness.dark);
              } else {
                Theme.of(context).copyWith(brightness: Brightness.light);
              }
            },
          ),
          // Delete All Data Button
          ListTile(
            leading: Icon(Icons.delete, color: isDarkMode ? Colors.white : Colors.purple),
            title: Text(
              'Delete All Data',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            onTap: _deleteAllData,
          ),
        ],
      ),
    );
  }
}
