import 'package:flutter/material.dart';

class SecurityQuestionsSetupPage extends StatelessWidget {
  final TextEditingController _motherMaidenNameController = TextEditingController();
  final TextEditingController _bestFriendController = TextEditingController();
  final TextEditingController _childhoodPetController = TextEditingController();
  final TextEditingController _customQuestionController = TextEditingController();
  final TextEditingController _customAnswerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Security Questions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
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
            TextField(
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
            ),
            SizedBox(height: 20),

            // Childhood Best Friend's Name Question
            Text('Childhood Best Friend\'s Name'),
            SizedBox(height: 8),
            TextField(
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
            ),
            SizedBox(height: 20),

            // Childhood Pet's Name Question
            Text('Childhood Pet\'s Name'),
            SizedBox(height: 8),
            TextField(
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
            ),
            SizedBox(height: 20),

            // Custom Question
            Text('Your Own Question'),
            SizedBox(height: 8),
            TextField(
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
            ),
            SizedBox(height: 20),

            // Answer for Custom Question
            TextField(
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
            ),
            SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Retrieve all answers
                  String motherMaidenName = _motherMaidenNameController.text;
                  String bestFriend = _bestFriendController.text;
                  String childhoodPet = _childhoodPetController.text;
                  String customQuestion = _customQuestionController.text;
                  String customAnswer = _customAnswerController.text;

                  if (motherMaidenName.isNotEmpty && bestFriend.isNotEmpty &&
                      childhoodPet.isNotEmpty && customQuestion.isNotEmpty && customAnswer.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Security questions saved successfully')),
                    );
                    Navigator.pushNamed(context, '/home'); // Navigate to home page after saving
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please answer all questions')),
                    );
                  }
                },
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
    );
  }
}
