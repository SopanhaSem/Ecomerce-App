import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/screen/checkout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatelessWidget {
  DetailController _controller = Get.put(DetailController());
  final Map data;
  final String refId;
  // final Function(Map) addToCart;

  // DetailScreen(
  //     {required this.data, required this.refId, required this.addToCart});

  DetailScreen({required this.data, required this.refId});

  @override
  Widget build(BuildContext context) {
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
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.favorite_border))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: CachedNetworkImage(
                      // height: 150, // Reduce image height to make space for text
                      // width: 200,
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
            _controller.addToCart(data);
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
