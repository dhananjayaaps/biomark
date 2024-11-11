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
  late final String name;
  late final String email;
  bool isDarkMode = false;
  String token = "";

  @override
  void initState() {
    print("initState");
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(Uri.parse('http://192.168.56.1:4000/details'),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'token=$token',
          }
      );
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          userDetails = jsonDecode(response.body)['userDetails'];
          print(userDetails);
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:4000/details/'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode(details),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        fetchUserDetails();
      }
      print(jsonEncode(details));
      print(response.body);
    } catch (error) {
      print("Error creating details: $error");
    }
  }

  Future<void> updateUserDetails(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    try {
      final response = await http.put(
        Uri.parse('http://192.168.56.1:4000/details'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode(details),
      );
      print(response);
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
      dobController.text = (existingDetails['dateOfBirth'] != null)
          ? DateTime.parse(existingDetails['dateOfBirth']).toLocal().toString().split(' ')[0]
          : '';
      birthTimeController.text = existingDetails['timeOfBirth'] ?? '';
      locationController.text = existingDetails['locationOfBirth'] ?? '';
      bloodGroup = existingDetails['bloodGroup'] ?? 'A+';
      sex = existingDetails['sex'] ?? 'Male';
      heightController.text = (existingDetails['height'] ?? '').toString();
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

  String getValueOrPlaceholder(dynamic value) {
    return value != null ? value.toString() : "N/A";
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
            Text(
              'User Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DataTable(
              columns: [
                DataColumn(label: Text('Field')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('Date of Birth')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['dateOfBirth']).substring(0, 10))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Time of Birth')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['timeOfBirth']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Location of Birth')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['locationOfBirth']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Blood Group')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['bloodGroup']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Sex')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['sex']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Height')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['height']) + " cm")),
                ]),
                DataRow(cells: [
                  DataCell(Text('Ethnicity')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['ethnicity']))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Eye Color')),
                  DataCell(Text(getValueOrPlaceholder(userDetails!['eyeColor']))),
                ]),
              ],
            ),
            SizedBox(height: 20),
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
