import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/screen/profile/changepassword.dart';
import 'package:ecomerces/src/screen/profile/editprofilescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  User? currentUser;
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
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(),
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      AssetImage('assets/img/custom_avatar3_3d-800x800.jpg'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.currentUser != null
                    ? widget.currentUser!.displayName ?? ''
                    : username,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.currentUser != null
                    ? widget.currentUser!.email ?? ''
                    : '',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                onTap: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        currentUser: FirebaseAuth.instance.currentUser,
                      ),
                    ),
                  );
                  if (updatedUser != null) {
                    setState(() {
                      widget.currentUser = updatedUser;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Account'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text(
                          "Are you sure you want to delete your account?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Delete user document from Firestore
                              try {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.currentUser!.uid)
                                    .delete();
                              } catch (error) {
                                print("Error deleting user document: $error");
                                // Optionally show an error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Failed to delete user document"),
                                  ),
                                );
                                return;
                              }

                              // Delete Firebase Authentication account
                              try {
                                await widget.currentUser!.delete();
                                // Successfully deleted account, navigate to login screen
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              } catch (error) {
                                print("Error deleting account: $error");
                                // Optionally show an error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to delete account"),
                                  ),
                                );
                              }
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
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
