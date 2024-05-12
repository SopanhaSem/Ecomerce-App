import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/auth/view/getstart_screen.dart';
import 'package:ecomerces/src/provider/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  SettingController controller = Get.put(SettingController());
  // TraslateLanguege lcontroller = Get.put(TraslateLanguege());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return SimpleBuilder(builder: (context) {
      return GetMaterialApp(
        onInit: () async {
          controller.onInitFont();
          // lcontroller.initlanguege();
        },
        debugShowCheckedModeBanner: false,
        theme: controller.theme,
        home: GetStarted(),
      );
    });
  }
}
