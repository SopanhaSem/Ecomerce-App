import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({required this.data, required this.refId});
  final Map data;
  final String refId;
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  DetailController _controller = Get.put(DetailController());

  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("userOrder");
  CollectionReference dataRef2 =
      FirebaseFirestore.instance.collection("historyOrder");
  DetailController controller = Get.put(DetailController());

  initData() {
    setState(() {
      widget.data['name'] = widget.data['hname'];
      widget.data['id'] = widget.data['hid'];
      widget.data['qty'] = widget.data['hqty'];
      widget.data['orderImg'] = widget.data['horderImg'];
      widget.data['price'] = widget.data['hprice'];
      widget.data['Phone'] = widget.data['hphone'];
      widget.data['username'] = widget.data['husername'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(builder: (contexts) {
      return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: dataRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // ignore: prefer_const_constructors
              return Center(
                child: const Icon(
                  Icons.info,
                  color: Colors.red,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return orderCard(context,
                        data: data, refId: snapshot.data!.docs[index].id);
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data!.docs.length);
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              // await dataRef.get().then((snapshot) {
              //   for (DocumentSnapshot doc in snapshot.docs) {
              //     doc.reference.delete();
              //   }
              // });
              if (widget.data == null) {
                await dataRef2.add({
                  'hid': widget.data['id'],
                  'hname': widget.data['name'],
                  'husername': widget.data['username'],
                  'horderImg': widget.data['orderImg'],
                  'hphone': widget.data['Phone'],
                  'hprice': widget.data[
                      'price'], // Make sure to use the correct price value
                  'hqty': widget.data['qty'],
                }).whenComplete(
                    () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order placed successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        ));
              } else {
                await dataRef2.doc(widget.refId).set({
                  'hid': widget.data['id'],
                  'hname': widget.data['name'],
                  'husername': widget.data['username'],
                  'horderImg': widget.data['orderImg'],
                  'hphone': widget.data['Phone'],
                  'hprice': widget.data[
                      'price'], // Make sure to use the correct price value
                  'hqty': widget.data['qty'],
                }).whenComplete(
                    () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order placed successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        ));
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent),
              child: Center(
                child: Text(
                  'Checkout'.toUpperCase(),
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
    });
  }
}

Widget orderCard(BuildContext context,
    {required Map data, required String refId}) {
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("userOrder");
  RxInt onQuantityChanged = RxInt(data['qty']);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        leading: CachedNetworkImage(
          imageUrl: data['orderImg'],
          width: 80.0,
          height: 80.0,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        title: Text(
          data['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (onQuantityChanged.value > 1) {
                  onQuantityChanged.value -= 1;
                }
              },
            ),
            Obx(
              () => Text(
                onQuantityChanged.value.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                onQuantityChanged.value += 1;
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await dataRef.doc(refId).delete();
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${data['price']}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            // Add any additional subtitle content here
          ],
        ),
        onTap: () {},
      ),
    ),
  );
}
