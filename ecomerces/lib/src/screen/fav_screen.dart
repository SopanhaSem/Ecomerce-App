import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
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
                        "Favorites",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
