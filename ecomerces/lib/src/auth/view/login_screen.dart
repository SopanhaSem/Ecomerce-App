import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/auth/authuser/user_authentication.dart';
import 'package:ecomerces/src/auth/view/signup_screen.dart';
import 'package:ecomerces/src/auth/widget/textfield.dart';
import 'package:ecomerces/src/screen/pageview.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isHintPassword = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/img/8997265.jpg'),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                child: Image.network(
                  'https://seeklogo.com/images/S/shopify-logo-1C711BCDE4-seeklogo.com.png',
                  fit: BoxFit.contain,
                ),
              ),
              TextFielWidget(
                prefixIcon: Icons.email,
                hintText: 'Enter E-mail',
                controller: emailcontroller,
              ),
              TextFielWidget(
                controller: passwordcontroller,
                prefixIcon: Icons.lock_open_rounded,
                hintText: 'Enter password',
                hintPassword: isHintPassword,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isHintPassword = !isHintPassword;
                      });
                    },
                    icon: Icon(isHintPassword
                        ? Icons.visibility
                        : Icons.visibility_off)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                    color: Colors.blueAccent,
                    child: const Text('Sign In'),
                    onPressed: () {
                      loginUser();
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You don't have account?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      "Create account",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    User? user = await _auth.signInWithEmailAndPassword(
        emailcontroller.text, passwordcontroller.text);

    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageViewScreen()),
          (route) => false);
    } else {
      print("Login failed");
    }
  }
}
