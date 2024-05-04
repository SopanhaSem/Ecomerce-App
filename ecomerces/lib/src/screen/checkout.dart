import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatelessWidget {
  final Function(Map) addToCart;
  DetailController _controller = Get.put(DetailController());
  CheckOutScreen({required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  _controller.productList.toString(),
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
      ),
    );
  }
}
