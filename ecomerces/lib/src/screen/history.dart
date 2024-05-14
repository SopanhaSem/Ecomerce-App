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
        title: const Text("History"),
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        leading: Image.network(
          data['orderImg'],
          width: 80.0,
          height: 80.0,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        ),
        title: Text(
          data['name'],
          style: TextStyle(
            fontSize: 15,
            fontFamily: fcontroller.fontTheme.value.toString(),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${data['price']}',
              style: TextStyle(
                fontSize: 15,
                fontFamily: fcontroller.fontTheme.value.toString(),
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
        onTap: () {},
      ),
    ),
  );
}
