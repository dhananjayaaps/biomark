import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  Future<void> deleteAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://192.168.56.1:4000/deleteAllData'),
      headers: {
        'Cookie': 'token=$token',
        'Content-Type': 'application/json',
      }
    );
    print(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All data deleted successfully')),
      );
      await prefs.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    }
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No authentication token found. Please log in.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.56.1:4000/changeEmail'),
        headers: {
          'Cookie': 'token=$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': newEmail}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email updated successfully')),
        );
      //   change the shared references too
        await prefs.setString('email', newEmail);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _confirmDeleteAllData() {
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
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteAllData();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _changeEmail() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Enter new email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newEmail = emailController.text;
                if (newEmail.isNotEmpty) {
                  Navigator.of(context).pop();
                  await changeEmail(newEmail);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid email')),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: isDarkMode ? Colors.white : Colors.purple),
            title: Text(
              'Change Email',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            onTap: _changeEmail,
          ),
          ListTile(
            leading: Icon(Icons.delete, color: isDarkMode ? Colors.white : Colors.purple),
            title: Text(
              'Delete All Data',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            onTap: _confirmDeleteAllData,
          ),
        ],
      ),
    );
  }
}
