import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Step 1: Email and security question data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motherMaidenNameController =
  TextEditingController();
  final TextEditingController _bestFriendController = TextEditingController();
  final TextEditingController _childhoodPetController =
  TextEditingController();
  final TextEditingController _customAnswerController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  bool isSecurityQuestionsVisible = false;
  bool isPasswordChangePageVisible = false;

  String? email;

  late final String customQuestion;

  // Step 2: Function to check email and load security questions
  Future<void> checkEmailAndLoadQuestions() async {
    if (_formKey.currentState!.validate()) {
      email = _emailController.text;

      try {
        final response = await http.post(
          Uri.parse('http://192.168.56.1:4000/user/check-email'), // Replace with your backend URL
          body: json.encode({'email': email}),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          final securityQuestions = json.decode(response.body)['securityQuestions'];
          customQuestion = securityQuestions['customQuestion'];
          print(customQuestion);
          setState(() {
            isSecurityQuestionsVisible = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email not found')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }
  // validate answers
  Future<void> verifySecurityAnswersAndShowPasswordForm() async {
    String motherMaidenName = _motherMaidenNameController.text;
    String bestFriend = _bestFriendController.text;
    String childhoodPet = _childhoodPetController.text;
    String customAnswer = _customAnswerController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:4000/user/verify-answers'),
        body: json.encode({
          'email': email,
          'motherMaidenName': motherMaidenName,
          'bestFriend': bestFriend,
          'childhoodPet': childhoodPet,
          'customAnswer': customAnswer,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isPasswordChangePageVisible = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect answers')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // Step 4: Function to change the password
  Future<void> changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://192.168.56.1:4000/user/change-password'), // Replace with your backend URL
        body: json.encode({
          'email': email,
          'newPassword': _newPasswordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (!isSecurityQuestionsVisible && !isPasswordChangePageVisible)
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter your email to proceed with password reset.'),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: checkEmailAndLoadQuestions,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            if (isSecurityQuestionsVisible && !isPasswordChangePageVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Answer the following security questions:'),
                  SizedBox(height: 16),
                  TextField(
                    controller: _motherMaidenNameController,
                    decoration: InputDecoration(
                      labelText: "Mother's Maiden Name",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _bestFriendController,
                    decoration: InputDecoration(
                      labelText: "Childhood Best Friend's Name",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _childhoodPetController,
                    decoration: InputDecoration(
                      labelText: "Childhood Pet's Name",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _customAnswerController,
                    decoration: InputDecoration(
                      labelText: customQuestion,
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: verifySecurityAnswersAndShowPasswordForm,
                    child: Text('Submit Answers'),
                  ),
                ],
              ),
            if (isPasswordChangePageVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter your new password:'),
                  SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // You should pass the values from the password text fields here
                      changePassword();
                    },
                    child: Text('Change Password'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
