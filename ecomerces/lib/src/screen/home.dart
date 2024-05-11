import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/screen/detail.dart';
import 'package:ecomerces/src/screen/profile/profilesetting.dart';
import 'package:ecomerces/src/screen/userorder_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("products");
  int index = 0;
  SettingController controller = Get.put(SettingController());
  final DetailController _detailController = Get.put(DetailController());
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: ListTile(
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundImage: AssetImage(
                          'assets/img/custom_avatar3_3d-800x800.jpg'),
                    ),
                    title: Text(
                      currentUser?.email?.split('@').first ?? '',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    subtitle: Text(
                      currentUser?.email ?? '',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage("https://i.imgur.com/ca5GXkg.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Colors.black,
                    child: Icon(
                        controller.isDark ? Icons.dark_mode : Icons.light_mode),
                  ),
                  trailing: CupertinoSwitch(
                    value: controller.isDark,
                    onChanged: controller.changeTheme,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  trailing: Icon(Icons.person),
                  title: Text(
                    'Profile',
                    style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                  ),
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
                ListTile(
                  trailing: Icon(Icons.favorite),
                  title: Text(
                    'Favorite',
                    style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  trailing: Icon(Icons.shopping_bag_sharp),
                  title: Text(
                    'My Order',
                    style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  trailing: Icon(Icons.settings),
                  title: Text(
                    'Setting',
                    style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                  ),
                  onTap: () {},
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
        ),
        appBar: AppBar(
          title: const Text("Home"),
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
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            }),
      ),
    );
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

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: 3000,

      /// Loops back to first slide.
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
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                t2,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito",
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
          tabs: const [
            Tab(
              child: Text(
                "Wearable",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Tab(
              child: Text(
                "Laptops",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Tab(
              child: Text(
                "Phones",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Tab(
              child: Text(
                "Drones",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Tab(
              child: Text(
                "Watch",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Tab(
              child: Text(
                "Keyboard",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nunito",
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
          borderRadius: BorderRadius.circular(10), // Set border radius here
        ),
        elevation: 3,
        child: Stack(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CachedNetworkImage(
                height: 150, // Reduce image height to make space for text
                width: 200,
                imageUrl: data['pImg'],
                fit:
                    BoxFit.contain, // Use BoxFit.cover to maintain aspect ratio
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    data['pName'],
                    style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${data['pPrice'].toString()}",
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            const Positioned(
              right: 0,
              child: Icon(
                Icons.star,
                size: 35,
                color: Color.fromARGB(207, 255, 255, 0),
                shadows: [
                  BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0.5,
                      offset: Offset(0, 0.2),
                      color: Colors.black)
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
