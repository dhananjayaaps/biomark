import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SecurityQuestionsSetupPage extends StatefulWidget {
  @override
  _SecurityQuestionsSetupPageState createState() =>
      _SecurityQuestionsSetupPageState();
}

class _SecurityQuestionsSetupPageState
    extends State<SecurityQuestionsSetupPage> {
  // TextEditingControllers for the form fields
  final TextEditingController _motherMaidenNameController =
  TextEditingController();
  final TextEditingController _bestFriendController = TextEditingController();
  final TextEditingController _childhoodPetController =
  TextEditingController();
  final TextEditingController _customQuestionController =
  TextEditingController();
  final TextEditingController _customAnswerController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Function to send data to the backend
  Future<void> saveSecurityQuestions() async {
    if (_formKey.currentState!.validate()) {
      // Gather the data from the text controllers
      final String motherMaidenName = _motherMaidenNameController.text;
      final String bestFriend = _bestFriendController.text;
      final String childhoodPet = _childhoodPetController.text;
      final String customQuestion = _customQuestionController.text;
      final String customAnswer = _customAnswerController.text;

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'securityQuestions': {
          'motherMaidenName': motherMaidenName.toLowerCase(),
          'bestFriend': bestFriend.toLowerCase(),
          'childhoodPet': childhoodPet.toLowerCase(),
          'customQuestion': customQuestion.toLowerCase(),
          'customAnswer': customAnswer,
        }
      };

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        final response = await http.put(
          Uri.parse('http://192.168.56.1:4000/user/update'),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'token=$token',
          },
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Security questions saved successfully!')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save security questions.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Security Questions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please set up answers to the following security questions.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Mother's Maiden Name Question
              Text('Mother\'s Maiden Name'),
              SizedBox(height: 8),
              TextFormField(
                controller: _motherMaidenNameController,
                decoration: InputDecoration(
                  hintText: 'Enter answer',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Childhood Best Friend's Name Question
              Text('Childhood Best Friend\'s Name'),
              SizedBox(height: 8),
              TextFormField(
                controller: _bestFriendController,
                decoration: InputDecoration(
                  hintText: 'Enter answer',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Childhood Pet's Name Question
              Text('Childhood Pet\'s Name'),
              SizedBox(height: 8),
              TextFormField(
                controller: _childhoodPetController,
                decoration: InputDecoration(
                  hintText: 'Enter answer',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Custom Question
              Text('Your Own Question'),
              SizedBox(height: 8),
              TextFormField(
                controller: _customQuestionController,
                decoration: InputDecoration(
                  hintText: 'Enter your own security question',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a custom question';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Answer for Custom Question
              TextFormField(
                controller: _customAnswerController,
                decoration: InputDecoration(
                  hintText: 'Answer to your custom question',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide an answer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveSecurityQuestions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
