import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/model/fav_product.dart';
import 'package:ecomerces/src/provider/fav_provider.dart';
import 'package:ecomerces/src/screen/userorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  DetailController _controller = Get.put(DetailController());
  final Map data;
  final String refId;
  DetailScreen({required this.data, required this.refId});

  @override
  Widget build(BuildContext context) {
    Product product = Product(
      id: refId,
      name: data['pName'],
      imageUrl: data['pImg'],
      price: double.parse(data['pPrice'].toString()),
    );
    var favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    return Scaffold(
      body: GetBuilder<DetailController>(builder: (contexts) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Builder(
                    builder: (contexts) => IconButton(
                      onPressed: () {
                        var favoritesProvider = Provider.of<FavoritesProvider>(
                            context,
                            listen: false);
                        if (!favoritesProvider.isFavorite(product.id)) {
                          favoritesProvider.addToFavorites(product);
                        } else {
                          favoritesProvider.removeFromFavorites(product.id);
                        }
                      },
                      icon: Icon(
                        Provider.of<FavoritesProvider>(context)
                                .isFavorite(product.id)
                            ? Icons
                                .favorite // If already in favorites, show filled heart
                            : Icons
                                .favorite_border, // Otherwise, show empty heart
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: CachedNetworkImage(
                      imageUrl: data['pImg'],
                      fit: BoxFit
                          .contain, // Use BoxFit.cover to maintain aspect ratio
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${data['pName']}',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Tune in to the Make it Big Podcast — our thought leadership audio series for retailers, entrepreneurs and ecommerce professionals. You ll get expert insights, strategies and tactics to help grow your business...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Full Description"),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(68, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total :",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Nunito",
                              ),
                            ),
                            Text(
                              '\$${data['pPrice']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Nunito",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderScreen(
                          data: data,
                          refId: refId,
                        )));
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent),
            child: Center(
              child: Text(
                'Add to basket'.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Nunito",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
