import 'package:get/get.dart';

class DetailController extends GetxController {
  // Define your product list
  final RxList<Map> productList = <Map>[].obs;

  // Method to add a product to the cart
  void addToCart(Map productData) {
    if (productList.isEmpty) {
      productList.add(productData);
    } else {
      int index = productList
          .indexWhere((element) => element['id'] == productData['id']);
      if (index == -1) {
        productList.add(productData);
      } else {
        // Increment the quantity if the product is already in the cart
        productList[index]['qty'] = productList[index]['qty'] + 1;
      }
    }
  }
}
