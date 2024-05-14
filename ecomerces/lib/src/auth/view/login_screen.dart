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

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late bool isHintPassword = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/img/8997265.jpg'),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Image.network(
                            'https://seeklogo.com/images/S/shopify-logo-1C711BCDE4-seeklogo.com.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: TextFielWidget(
                          prefixIcon: Icons.email,
                          hintText: 'Enter E-mail',
                          controller: emailcontroller,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: TextFielWidget(
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
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: CupertinoButton(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            loginUser();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You don't have account?",
                              style: TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                );
                              },
                              child: Text(
                                "Create account",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    final currentContext = _scaffoldKey.currentContext;
    if (currentContext != null) {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  void loginUser() async {
    User? user = await _auth.signInWithEmailAndPassword(
        emailcontroller.text, passwordcontroller.text);

    if (user != null) {
      // Save user email and password to Firestore
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': emailcontroller.text,
          'password': passwordcontroller
              .text, // Note: Storing passwords in plain text is not recommended for security reasons.
        });
        print('Email and password saved to Firestore.');

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PageViewScreen()),
            (route) => false);
      } catch (e) {
        _showSnackBar('Failed to save email and password to Firestore.');
      }
    } else {
      _showSnackBar('Incorrect email or password.');
    }
  }
}
