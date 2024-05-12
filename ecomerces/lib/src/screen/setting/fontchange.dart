import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeFontScreen extends StatelessWidget {
  ChangeFontScreen({super.key});
  SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (contexts) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'fonts'.tr,
              style:
                  TextStyle(fontFamily: controller.fontTheme.value.toString()),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: List.generate(
              controller.listFont.length,
              (index) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.onSelectFont(
                                    fontName: controller.listFont[index]);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    controller.listFont[index],
                                    style: TextStyle(
                                        fontSize: 45,
                                        fontFamily: controller.listFont[index]),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                            controller.fontTheme.toString() ==
                                                    controller.listFont[index]
                                                ? Colors.blueAccent
                                                : null,
                                      ),
                                      child: Center(
                                        child:
                                            controller.fontTheme.toString() ==
                                                    controller.listFont[index]
                                                ? const Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  )
                                                : const SizedBox(),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
