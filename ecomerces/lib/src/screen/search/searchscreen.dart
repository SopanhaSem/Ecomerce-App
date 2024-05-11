import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _searchProducts(value);
                    } else {
                      // Reset the stream if the search query is empty
                      _resetSearch();
                    }
                  });
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
                    return SingleChildScrollView(
                      child: Column(
                        children: [
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
    return GestureDetector(
      onTap: () {
        // Navigate to product details screen
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
                child: Image.network(
                  data['pImg'],
                  height: 150, // Reduce image height to make space for text
                  width: 200,
                  fit: BoxFit
                      .contain, // Use BoxFit.cover to maintain aspect ratio
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

  void _searchProducts(String query) {
    setState(() {
      _searchController.clear();
      _searchController.text = query;
    });
  }

  void _resetSearch() {
    setState(() {
      _searchController.clear();
    });
  }
}
