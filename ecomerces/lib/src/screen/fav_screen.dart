import 'package:ecomerces/src/Getx/controller/controller.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/model/fav_product.dart';
import 'package:ecomerces/src/provider/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  final DetailController controller = Get.put(DetailController());
  final SettingController fcontroller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(
            fontSize: 20,
            fontFamily: fcontroller.fontTheme.value.toString(),
            fontWeight: FontWeight.bold,
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
      body: GetBuilder<DetailController>(
        builder: (context) {
          return Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              List<Product> favorites = favoritesProvider.favorites;
              if (favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No favorite products yet.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: fcontroller.fontTheme.value.toString(),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  Product product = favorites[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: fcontroller.fontTheme.value.toString(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '\$${product.price}',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            var favoritesProvider =
                                Provider.of<FavoritesProvider>(context,
                                    listen: false);
                            if (!favoritesProvider.isFavorite(product.id)) {
                              favoritesProvider.addToFavorites(product);
                            } else {
                              favoritesProvider.removeFromFavorites(product.id);
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Icon(
                              favoritesProvider.isFavorite(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey<bool>(
                                  favoritesProvider.isFavorite(product.id)),
                              color: Colors.red,
                            ),
                          ),
                        ),
                        onTap: () {
                          // Add your onTap logic here
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
