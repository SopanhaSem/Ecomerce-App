import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/screen/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("products");
  int index = 0;
  final DetailController _detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<DetailController>(
            init: DetailController(),
            builder: (context) {
              return StreamBuilder<QuerySnapshot>(
                stream: dataRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Icon(
                        Icons.info,
                        color: Colors.red,
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            searchBar(),
                            title("Order Online", "Collect In Store"),
                            tabBar(),
                            const SizedBox(height: 20),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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

  Widget searchBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              splashColor: Colors.blue,
              onTap: () {},
              child: Image.asset(
                "assets/icon/menus.png",
                fit: BoxFit.cover,
                height: 30,
              ),
            ),
            SizedBox(
              width: 250,
              child: TextField(
                style: TextStyle(fontSize: 20, fontFamily: "Nunito"),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  prefixIcon: Image(
                    image: AssetImage("assets/icon/big-magnifying-glass.png"),
                  ),
                  hintText: "Search",
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
                style: TextStyle(
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
          tabs: [
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
      // Get.to(DetailScreen(data: data, refId: refId));
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
            Container(
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
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${data['pPrice'].toString()}",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
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
