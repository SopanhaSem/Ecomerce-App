import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({required this.data, required this.refId});
  final Map data;
  final String refId;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("userOrder");
  RxInt onQuantityChanged = 1.obs;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  DetailController controller = Get.put(DetailController());

  initData() {
    setState(() {
      usernamecontroller.text = widget.data['username'];
      phonecontroller.text = widget.data['Phone'].toString();
      onQuantityChanged = widget.data['qty'];
      widget.data['pPrice'] = widget.data['price'];
      widget.data['userImg'] = widget.data['pImg'];
      widget.data['pID'] = widget.data['id'];
      widget.data['pName'] = widget.data['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DetailController>(builder: (contexts) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  const SizedBox(
                    width: 120,
                  ),
                  const Text(
                    "Order",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              inputOrder(
                hintText: "Enter your Name",
                controller: usernamecontroller,
              ),
              const SizedBox(
                height: 30,
              ),
              inputOrder(
                hintText: "Phone",
                controller: phonecontroller,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.data['pName'],
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: CachedNetworkImage(
                  imageUrl: widget.data['pImg'],
                  fit: BoxFit
                      .contain, // Use BoxFit.cover to maintain aspect ratio
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 30,
                    ),
                    onPressed: () {
                      if (onQuantityChanged.value > 1) {
                        onQuantityChanged.value -= 1;
                      }
                    },
                  ),
                  Obx(() => Text(
                        onQuantityChanged.value.toString(),
                        style: TextStyle(fontSize: 16.0),
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () {
                      onQuantityChanged.value += 1;
                    },
                  ),
                ],
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
                        Obx(
                          () => Text(
                            '\$${(widget.data['pPrice'] * onQuantityChanged.value).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (widget.data == null) {
              await dataRef.add({
                'id': widget.data['pID'],
                'username': usernamecontroller.text,
                'name': widget.data['pName'],
                'orderImg': widget.data['pImg'],
                'Phone': phonecontroller.text,
                'price': widget
                    .data['pPrice'], // Make sure to use the correct price value
                'qty': onQuantityChanged.value,
              }).whenComplete(() => Navigator.pop(context));
            } else {
              await dataRef.doc(widget.refId).set({
                'id': widget.data['id'],
                'username': usernamecontroller.text,
                'name': widget.data['pName'],
                'orderImg': widget.data['pImg'],
                'Phone': phonecontroller.text,
                'price': widget
                    .data['pPrice'], // Make sure to use the correct price value
                'qty': onQuantityChanged.value,
              }).whenComplete(() => Navigator.pop(context));
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent),
            child: Center(
              child: Text(
                'Confirm'.toUpperCase(),
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

Widget inputOrder({
  required String? hintText,
  required TextEditingController? controller,
}) {
  return SizedBox(
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}
