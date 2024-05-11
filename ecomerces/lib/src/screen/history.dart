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
    children: [
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
