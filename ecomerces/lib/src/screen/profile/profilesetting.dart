import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/auth/authuser/user_authentication.dart';
import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final User? currentUser;
  ProfileView({super.key, this.currentUser});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    String username = widget.currentUser?.email?.split('@').first ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      AssetImage('assets/img/custom_avatar3_3d-800x800.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                username,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.currentUser?.email ?? ''}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile'),
                onTap: () {
                  // Add functionality for editing profile
                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Change Password'),
                onTap: () {
                  // Add functionality for changing password
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notification Settings'),
                onTap: () {
                  // Add functionality for notification settings
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Account'),
                onTap: () {
                  // Add functionality for deleting account
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().whenComplete(() =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
