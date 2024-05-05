import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/screen/checkout.dart';
import 'package:ecomerces/src/screen/fav_screen.dart';
import 'package:ecomerces/src/screen/history.dart';
import 'package:ecomerces/src/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key}) : super(key: key);

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  final DetailController _detailController = Get.put(
      DetailController()); // Use Get.put to initialize and manage controllers

  late PageController _controller;
  final RxInt _selectedIndex = 0.obs; // Use RxInt for reactive updates

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          FavoriteScreen(),
          HistoryScreen(),
          CheckOutScreen(data: {}, refId: ""),
        ],
        onPageChanged: (index) {
          _selectedIndex.value = index;
        },
      ),
      bottomNavigationBar: Obx(() => SlidingClippedNavBar(
            selectedIndex: _selectedIndex.value,
            backgroundColor: Colors.white,
            onButtonPressed: (index) {
              _controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad,
              );
            },
            iconSize: 30,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.black,
            barItems: [
              BarItem(
                icon: Icons.home,
                title: 'Home',
              ),
              BarItem(
                icon: Icons.favorite,
                title: 'Favorite',
              ),
              BarItem(
                icon: Icons.history,
                title: 'Order History',
              ),
              BarItem(
                icon: Icons.shopping_bag,
                title: 'Checkout',
              ),
            ],
          )),
    );
  }
}
