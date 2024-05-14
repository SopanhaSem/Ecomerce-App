import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final DetailController _controller = Get.put(DetailController());
  final CollectionReference orderHistoryRef =
      FirebaseFirestore.instance.collection('orderHistory');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Nunito",
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
        stream: orderHistoryRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return noHistory();
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return orderCard(context, data: data);
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ),
    );
  }
}

Widget noHistory() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, size: 100, color: Colors.grey),
        SizedBox(height: 20),
        Text(
          "No History",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget orderCard(BuildContext context, {required Map data}) {
  SettingController fcontroller = Get.put(SettingController());
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
            placeholder: (context, url) => Container(
              width: 80.0,
              height: 80.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
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
