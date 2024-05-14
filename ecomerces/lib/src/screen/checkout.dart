import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/Getx/controller/controller.dart';
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

  CollectionReference userOrderRef =
      FirebaseFirestore.instance.collection("userOrder");
  CollectionReference orderHistoryRef =
      FirebaseFirestore.instance.collection("orderHistory");

  DetailController controller = Get.put(DetailController());
  SettingController fcontroller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(builder: (contexts) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            style: TextStyle(
              fontSize: 20,
              fontFamily: fcontroller.fontTheme.value.toString(),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: userOrderRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
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
              QuerySnapshot snapshot = await userOrderRef.get();
              for (DocumentSnapshot doc in snapshot.docs) {
                // Save to orderHistory
                await orderHistoryRef.add(doc.data() as Map<String, dynamic>);
                // Delete from userOrder
                await doc.reference.delete();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'All orders placed successfully!',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: fcontroller.fontTheme.value.toString(),
                    ),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Center(
                child: Text(
                  'Checkout'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: fcontroller.fontTheme.value.toString(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
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
  SettingController fcontroller = Get.put(SettingController());
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("userOrder");
  RxInt onQuantityChanged = RxInt(data['qty']);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: data['orderImg'],
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(
          data['name'],
          style: TextStyle(
            fontSize: 16,
            fontFamily: fcontroller.fontTheme.value.toString(),
            fontWeight: FontWeight.bold,
          ),
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
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: fcontroller.fontTheme.value.toString(),
                  fontWeight: FontWeight.bold,
                ),
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
              style: TextStyle(
                fontSize: 16,
                fontFamily: fcontroller.fontTheme.value.toString(),
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(data['name']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: data['orderImg'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${data['price']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: fcontroller.fontTheme.value.toString(),
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    data['description'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: fcontroller.fontTheme.value.toString(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: fcontroller.fontTheme.value.toString(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
