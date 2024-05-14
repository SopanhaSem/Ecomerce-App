import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/screen/profile/changepassword.dart';
import 'package:ecomerces/src/screen/profile/editprofilescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Getx/controller/controller.dart';

class ProfileView extends StatefulWidget {
  User? currentUser;
  ProfileView({super.key, this.currentUser});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    String username = widget.currentUser?.email?.split('@').first ?? '';
    return GetBuilder<SettingController>(
      builder: (contexts) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 18,
                fontFamily: controller.fontTheme.value.toString(),
              ),
            ),
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
                      backgroundImage: AssetImage(
                          'assets/img/custom_avatar3_3d-800x800.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.currentUser != null
                        ? widget.currentUser!.displayName ?? ''
                        : username,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: controller.fontTheme.value.toString(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.currentUser?.email ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: controller.fontTheme.value.toString(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: controller.fontTheme.value.toString(),
                      ),
                    ),
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
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: controller.fontTheme.value.toString(),
                      ),
                    ),
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
                    title: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: controller.fontTheme.value.toString(),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Confirm Delete",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily:
                                    controller.fontTheme.value.toString(),
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to delete your account?",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily:
                                    controller.fontTheme.value.toString(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
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
                                    print(
                                        "Error deleting user document: $error");
                                    // Optionally show an error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to delete user document",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: controller
                                                .fontTheme.value
                                                .toString(),
                                          ),
                                        ),
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
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } catch (error) {
                                    print("Error deleting account: $error");
                                    // Optionally show an error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to delete account",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: controller
                                                .fontTheme.value
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily:
                                        controller.fontTheme.value.toString(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: controller.fontTheme.value.toString(),
                      ),
                    ),
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
      },
    );
  }
}
