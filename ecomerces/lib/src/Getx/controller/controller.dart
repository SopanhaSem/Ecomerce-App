import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  RxString fontTheme = ''.obs;
  void onInitFont() async {
    var prefs = await SharedPreferences.getInstance();
    fontTheme(prefs.getString('font') ?? 'Roboto');
    update();
  }

  RxList<String> listFont = ['Roboto', 'Anta', 'Honk', 'Madimi', 'khbb'].obs;
  // void changeFontThem() async {
  //   // fontTheme.value = fontUse.value;
  //   var prefs = await SharedPreferences.getInstance();
  //   fontTheme(prefs.getString('font') ?? 'Anta');
  //   update();
  // }

  void onSelectFont({required String fontName}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('font', fontName);
    onInitFont();
    update();
  }

  final box = GetStorage();
  bool get isDark => box.read('darkmode') ?? false;
  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();
  void changeTheme(bool value) => box.write('darkmode', value);
}
