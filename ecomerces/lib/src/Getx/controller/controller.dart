import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  // //change fonts
  // RxString fontTheme = ''.obs;
  // void onInitFont() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   fontTheme(prefs.getString('font') ?? 'Anta');
  //   update();
  // }

  // RxList<String> listFont = ['Anta', 'Honk', 'MadimiOne', 'khbb'].obs;
  // // void changeFontThem() async {
  // //   // fontTheme.value = fontUse.value;
  // //   var prefs = await SharedPreferences.getInstance();
  // //   fontTheme(prefs.getString('font') ?? 'Anta');
  // //   update();
  // // }

  // void onSelectFont({required String fontName}) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   prefs.setString('font', fontName);
  //   onInitFont();
  //   update();
  // }

  // //change theme
  final box = GetStorage();
  bool get isDark => box.read('darkmode') ?? false;
  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();
  void changeTheme(bool value) => box.write('darkmode', value);
}
