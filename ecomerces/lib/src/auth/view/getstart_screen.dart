import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/img/8997265.jpg',
            ),
          ),
        ),
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
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              color: Colors.blueAccent,
              child: const Text('Get started'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
