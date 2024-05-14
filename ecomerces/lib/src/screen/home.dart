import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/screen/checkout.dart';
import 'package:ecomerces/src/screen/detail.dart';
import 'package:ecomerces/src/screen/fav_screen.dart';
import 'package:ecomerces/src/screen/profile/profilesetting.dart';
import 'package:ecomerces/src/screen/search/searchscreen.dart';
import 'package:ecomerces/src/screen/setting/fontchange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("products");
  int index = 0;
  SettingController controller = Get.put(SettingController());
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (contextss) {
      return DefaultTabController(
        length: 6,
        child: Scaffold(
          drawer: SafeArea(
            child: GetBuilder<SettingController>(builder: (contexts) {
              return Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                          image:
                              NetworkImage("https://i.imgur.com/ca5GXkg.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              'assets/img/custom_avatar3_3d-800x800.jpg',
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                '',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: controller.fontTheme.value.toString(),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser?.email ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: controller.fontTheme.value.toString(),
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildListTile(
                      icon: Icons.lightbulb_outline,
                      title: 'Theme',
                      trailing: CupertinoSwitch(
                        value: controller.isDark,
                        onChanged: controller.changeTheme,
                      ),
                      onTap: () {},
                    ),
                    _buildListTile(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileView(
                                currentUser: FirebaseAuth.instance.currentUser),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.favorite,
                      title: 'Favorite',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoriteScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.shopping_bag,
                      title: 'My Order',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckOutScreen(
                              data: {}, // Pass the data parameter
                              refId: "", // Pass the refId parameter
                            ),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.settings,
                      title: 'Setting',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeFontScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.logout,
                      title: 'Log Out',
                      onTap: () {
                        FirebaseAuth.instance.signOut().whenComplete(
                              () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
          appBar: AppBar(
            title: Text(
              "Home",
              style:
                  TextStyle(fontFamily: controller.fontTheme.value.toString()),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: GetBuilder<DetailController>(
            init: DetailController(),
            builder: (context) {
              return StreamBuilder<QuerySnapshot>(
                stream: dataRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Icon(
                        Icons.info,
                        color: Colors.red,
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            banner(),
                            title("Order Online", "Collect In Store"),
                            tabBar(),
                            const SizedBox(height: 20),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: 2 / 3,
                              ),
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                return productCard(
                                  context,
                                  data: data,
                                  refId: snapshot.data!.docs[index].id,
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      );
    });
  }

  Widget banner() {
    return ImageSlideshow(
      width: double.infinity,
      height: 200,
      initialPage: 0,
      indicatorColor: Colors.blue,
      indicatorBackgroundColor: Colors.grey,
      children: [
        Image.asset(
          "assets/img/34b5bf180145769.6505ae7623131.jpg",
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/img/digital-smart-watch-banner-design-template-d7aa954477c61d4aaf74a2001b70e98f_screen.jpg',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/img/maxresdefault.jpg',
          fit: BoxFit.cover,
        ),
      ],
      onPageChanged: (value) {
        print('Page changed: $value');
      },
      autoPlayInterval: 3000,
      isLoop: true,
    );
  }

  Widget title(String t1, String t2) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 30, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t1,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                t2,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: TabBar(
          onTap: (value) {},
          isScrollable: true,
          tabs: [
            Tab(
              child: Text(
                "Wearable",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Laptops",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Phones",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Drones",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Watch",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Keyboard",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: controller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget productCard(BuildContext context,
    {required Map data, required String refId}) {
  SettingController controller = Get.put(SettingController());
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(data: data, refId: refId),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: CachedNetworkImage(
                height: 150,
                width: double.infinity,
                imageUrl: data['pImg'],
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['pName'],
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: controller.fontTheme.value.toString(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "\$${data['pPrice'].toString()}",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: controller.fontTheme.value.toString(),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildListTile({
  required IconData icon,
  required String title,
  Widget? trailing,
  required VoidCallback onTap,
}) {
  SettingController controller = Get.put(SettingController());
  return ListTile(
    leading: Icon(icon, color: Colors.blue),
    trailing:
        trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.grey),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontFamily: controller.fontTheme.value.toString(),
      ),
    ),
    onTap: onTap,
  );
}
