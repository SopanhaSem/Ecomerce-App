import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  DetailController _controller = Get.put(DetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: ListTile(
                leading: CircleAvatar(
                  maxRadius: 30,
                  backgroundImage: AssetImage(
                      'assets/img/depressed-businessman-isolated_1401-46.jpg'),
                ),
                title: Text("Name"),
                subtitle: Text("email"),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              trailing: Icon(Icons.person),
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
              ),
              onTap: () {
                // Add your navigation logic here
              },
            ),
            ListTile(
              trailing: Icon(Icons.favorite),
              title: Text(
                'Favorite',
                style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
              ),
              onTap: () {
                // Add your navigation logic here
              },
            ),
            ListTile(
              trailing: Icon(Icons.shopping_bag_sharp),
              title: Text(
                'My Order',
                style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
              ),
              onTap: () {
                // Add your navigation logic here
              },
            ),
            ListTile(
              trailing: Icon(Icons.settings),
              title: Text(
                'Setting',
                style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
              ),
              onTap: () {
                // Add your navigation logic here
              },
            ),
            ListTile(
              trailing: Icon(Icons.login_outlined),
              title: Text(
                'Log Out',
                style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
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
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: GetBuilder<DetailController>(
          init: DetailController(),
          builder: (contexts) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: noHistory(),
            );
          }),
    );
  }
}

Widget noHistory() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset("assets/img/depressed-businessman-isolated_1401-46.jpg"),
      Text(
        "No History",
        style: TextStyle(
          fontSize: 20,
          fontFamily: "Nunito",
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
