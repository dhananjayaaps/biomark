import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final Function(bool) toggleTheme;
  HomePage(this.toggleTheme);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  String name = 'Loading...';
  String email = 'Loading...';
  bool isDarkMode = false;
  String token = "";

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'No Name';
      email = prefs.getString('email') ?? 'No Email';
      token = prefs.getString('token') ?? '';
      isDarkMode = Theme.of(context).brightness == Brightness.dark;
    });
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:4000/details'),
          headers: {
            'Cookie': 'token=$token',
          }
      );
      if (response.statusCode == 200) {
        setState(() {
          userDetails = jsonDecode(response.body)['userDetails'];
          isLoading = false;
        });
      } else {
        setState(() {
          userDetails = null;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        userDetails = null;
        isLoading = false;
      });
    }
  }

  Future<void> deleteUserDetails() async {
    try {
      final response = await http.delete(Uri.parse('http://192.168.56.1:4000/details'),
          headers: {
            'Cookie': 'token=$token',
          });
      if (response.statusCode == 200) {
        setState(() {
          userDetails = null;
        });
      }
    } catch (error) {
      print("Error deleting details: $error");
    }
  }

  Future<void> createUserDetails(Map<String, dynamic> details) async {
    print(name + email + token);
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:4000/details/'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode(details),
      );
      if (response.statusCode == 200) {
        fetchUserDetails();
      }
      print(jsonEncode(details));
      print(response.body);
    } catch (error) {
      print("Error creating details: $error");
    }
  }

  Future<void> updateUserDetails(Map<String, dynamic> details) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.56.1:4000/api/user/details'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(details),
      );
      if (response.statusCode == 200) {
        fetchUserDetails();
      }
    } catch (error) {
      print("Error updating details: $error");
    }
  }

  void showCreateOrUpdateForm({Map<String, dynamic>? existingDetails}) {
    final formKey = GlobalKey<FormState>();
    final dobController = TextEditingController();
    final birthTimeController = TextEditingController();
    final locationController = TextEditingController();
    final heightController = TextEditingController();
    final ethnicityController = TextEditingController();
    final eyeColorController = TextEditingController();
    String bloodGroup = 'A+';
    String sex = 'Male';

    if (existingDetails != null) {
      dobController.text = existingDetails['dateOfBirth'] ?? '';
      birthTimeController.text = existingDetails['timeOfBirth'] ?? '';
      locationController.text = existingDetails['locationOfBirth'] ?? '';
      bloodGroup = existingDetails['bloodGroup'] ?? 'A+';
      sex = existingDetails['sex'] ?? 'Male';
      heightController.text = existingDetails['height'] ?? '';
      ethnicityController.text = existingDetails['ethnicity'] ?? '';
      eyeColorController.text = existingDetails['eyeColor'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(existingDetails == null ? 'Create Details' : 'Update Details'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: dobController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dobController.text = pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                  TextFormField(
                    controller: birthTimeController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Time of Birth'),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        birthTimeController.text = pickedTime.format(context);
                      }
                    },
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location of Birth'),
                  ),
                  DropdownButtonFormField<String>(
                    value: bloodGroup,
                    items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                        .map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        bloodGroup = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Blood Group'),
                  ),
                  DropdownButtonFormField<String>(
                    value: sex,
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        sex = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Sex'),
                  ),
                  TextFormField(
                    controller: heightController,
                    decoration: InputDecoration(labelText: 'Height (cm)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: ethnicityController,
                    decoration: InputDecoration(labelText: 'Ethnicity'),
                  ),
                  TextFormField(
                    controller: eyeColorController,
                    decoration: InputDecoration(labelText: 'Eye Color'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final details = {
                    'dateOfBirth': dobController.text,
                    'timeOfBirth': birthTimeController.text,
                    'locationOfBirth': locationController.text,
                    'bloodGroup': bloodGroup,
                    'sex': sex,
                    'height': heightController.text,
                    'ethnicity': ethnicityController.text,
                    'eyeColor': eyeColorController.text,
                  };
                  if (existingDetails == null) {
                    createUserDetails(details);
                  } else {
                    updateUserDetails(details);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(existingDetails == null ? 'Create' : 'Update'),
            ),
          ],
        );
      },
    );
  }

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
            // Drawer header with user profile info
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    email,
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
                Navigator.pushNamed(context, '/profile');
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
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear SharedPreferences
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : userDetails != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Details Found'),
            Text('Date of Birth: ${userDetails!['dateOfBirth']}'),
            Text('Time of Birth: ${userDetails!['timeOfBirth']}'),
            Text('Location of Birth: ${userDetails!['locationOfBirth']}'),
            Text('Blood Group: ${userDetails!['bloodGroup']}'),
            Text('Sex: ${userDetails!['sex']}'),
            Text('Height: ${userDetails!['height']} cm'),
            Text('Ethnicity: ${userDetails!['ethnicity']}'),
            Text('Eye Color: ${userDetails!['eyeColor']}'),
            ElevatedButton(
              onPressed: () => showCreateOrUpdateForm(existingDetails: userDetails),
              child: Text('Update Details'),
            ),
            ElevatedButton(
              onPressed: deleteUserDetails,
              child: Text('Delete All Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Details Found'),
            ElevatedButton(
              onPressed: showCreateOrUpdateForm,
              child: Text('Create Details'),
            ),
          ],
        ),
      ),
    );
  }
}
