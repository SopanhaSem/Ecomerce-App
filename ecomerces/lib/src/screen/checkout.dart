import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  DetailController controller = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(builder: (contexts) {
      return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 30,
                    backgroundImage: AssetImage(
                        'assets/img/depressed-businessman-isolated_1401-46.jpg'),
                  ),
                  title: Text("Name"),
                  subtitle: Text("email"),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                trailing: Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                ),
                onTap: () {
                  // Add your navigation logic here
                },
              ),
              ListTile(
                trailing: Icon(Icons.favorite),
                title: Text(
                  'Favorite',
                  style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                ),
                onTap: () {
                  // Add your navigation logic here
                },
              ),
              ListTile(
                trailing: Icon(Icons.shopping_bag_sharp),
                title: Text(
                  'My Order',
                  style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                ),
                onTap: () {
                  // Add your navigation logic here
                },
              ),
              ListTile(
                trailing: Icon(Icons.settings),
                title: Text(
                  'Setting',
                  style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                ),
                onTap: () {
                  // Add your navigation logic here
                },
              ),
              ListTile(
                trailing: Icon(Icons.login_outlined),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut().whenComplete(() =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Checkout"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          ],
        ),
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
              await dataRef.get().then((snapshot) {
                for (DocumentSnapshot doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All orders placed successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
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
