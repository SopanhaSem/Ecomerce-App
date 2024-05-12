import 'package:ecomerces/src/auth/authuser/user_authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final User? currentUser;

  EditProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current user data
    _usernameController =
        TextEditingController(text: widget.currentUser?.displayName ?? '');
    _emailController =
        TextEditingController(text: widget.currentUser?.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call function to update profile
                _updateProfile();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
    try {
      print('Updating profile...');

      // Update display name
      await FirebaseAuthService()
          .updateDisplayName(_usernameController.text.trim());
      print('Display name updated successfully.');

      // Update email if it's changed
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != _emailController.text.trim()) {
        await user.updateEmail(_emailController.text.trim());
        print('Email updated successfully.');
      }

      // After updating the profile successfully, pass the updated user object back
      final updatedUser = FirebaseAuth.instance.currentUser;
      Navigator.pop(context, updatedUser);
    } catch (e) {
      // Handle error
      print("Failed to update profile: $e");
      // Display error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose text controllers
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
