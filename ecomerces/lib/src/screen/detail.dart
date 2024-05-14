import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/model/fav_product.dart';
import 'package:ecomerces/src/provider/fav_provider.dart';
import 'package:ecomerces/src/screen/userorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final DetailController _controller = Get.put(DetailController());
  final Map data;
  final String refId;

  DetailScreen({required this.data, required this.refId});

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.put(SettingController());
    final Product product = Product(
      id: refId,
      name: data['pName'],
      imageUrl: data['pImg'],
      price: double.parse(data['pPrice'].toString()),
    );

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
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      bool isFavorite =
                          favoritesProvider.isFavorite(product.id);
                      return IconButton(
                        onPressed: () {
                          if (!isFavorite) {
                            favoritesProvider.addToFavorites(product);
                          } else {
                            favoritesProvider.removeFromFavorites(product.id);
                          }
                        },
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey<bool>(isFavorite),
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
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
                      fit: BoxFit.contain,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fadeInDuration: const Duration(milliseconds: 500),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        data['pName'],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: controller.fontTheme.value.toString(),
                        ),
                      ),
                    ],
                  ),
                  ExpandableText(
                    text:
                        'Tune in to the Make it Big Podcast — our thought leadership audio series for retailers, entrepreneurs and ecommerce professionals. You ll get expert insights, strategies and tactics to help grow your business...',
                    controller: controller,
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
                                fontFamily:
                                    controller.fontTheme.value.toString(),
                              ),
                            ),
                            Text(
                              '\$${data['pPrice']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily:
                                    controller.fontTheme.value.toString(),
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
                builder: (context) => OrderScreen(data: data, refId: refId),
              ),
            );
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueAccent,
            ),
            child: Center(
              child: Text(
                'Add to basket'.toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: controller.fontTheme.value.toString(),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final SettingController controller;

  ExpandableText({required this.text, required this.controller});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isExpanded ? widget.text : widget.text.substring(0, 100) + '...',
          style: TextStyle(
            fontSize: 16,
            fontFamily: widget.controller.fontTheme.value.toString(),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Show Less" : "Show More",
            style: TextStyle(
              fontSize: 18,
              fontFamily: widget.controller.fontTheme.value.toString(),
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
