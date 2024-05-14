import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/screen/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final SettingController fcontroller = Get.put(SettingController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: fcontroller.fontTheme.value.toString(),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Trigger search when text changes
                  _searchProducts(value);
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: productsRef.snapshots(),
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
                    // Filter products based on search query
                    final filteredProducts = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final productName =
                          data['pName'].toString().toLowerCase();
                      final searchQuery = _searchController.text.toLowerCase();
                      return productName.contains(searchQuery);
                    }).toList();

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        var data = filteredProducts[index].data()
                            as Map<String, dynamic>;
                        return productCard(
                          context,
                          data: data,
                          refId: filteredProducts[index].id,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(BuildContext context,
      {required Map data, required String refId}) {
    SettingController fcontroller = Get.put(SettingController());
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
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Stack(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.network(
                  data['pImg'],
                  height: 150,
                  width: 200,
                  fit: BoxFit.contain,
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
                        fontSize: 20,
                        fontFamily: fcontroller.fontTheme.value.toString(),
                      ),
                    ),
                    Text(
                      "\$${data['pPrice'].toString()}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: fcontroller.fontTheme.value.toString(),
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
                      color: Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _searchProducts(String query) {
    setState(() {
      // Update the search query
    });
  }
}
