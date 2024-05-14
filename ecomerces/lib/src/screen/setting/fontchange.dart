import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeFontScreen extends StatelessWidget {
  ChangeFontScreen({super.key});
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (contexts) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'fonts'.tr,
            style: TextStyle(fontFamily: controller.fontTheme.value.toString()),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: List.generate(
            controller.listFont.length,
            (index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  controller.onSelectFont(fontName: controller.listFont[index]);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: controller.fontTheme.toString() ==
                            controller.listFont[index]
                        ? Colors.blue.withOpacity(0.3)
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.listFont[index],
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: controller.listFont[index]),
                        ),
                        if (controller.fontTheme.toString() ==
                            controller.listFont[index])
                          Icon(
                            Icons.done,
                            color: Colors.blue,
                          ),
                      ],
                    ),
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
