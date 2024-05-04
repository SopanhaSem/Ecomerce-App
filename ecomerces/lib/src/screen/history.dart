import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  DetailController _controller = Get.put(DetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DetailController>(
          init: DetailController(),
          builder: (contexts) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        "History",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      noHistory(),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

Widget noHistory() {
  return Column(
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
