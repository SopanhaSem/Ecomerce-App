import 'package:ecomerces/src/auth/view/login_screen.dart';
import 'package:ecomerces/src/controller/product_controller.dart';
import 'package:ecomerces/src/model/fav_product.dart';
import 'package:ecomerces/src/provider/fav_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  DetailController controller = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
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
                  child: Text(
                    'No favorite products yet.',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold),
                  ),
                );
              }

              // If there are favorite products, display them
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  Product product = favorites[index];
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '\$${product.price}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        var favoritesProvider = Provider.of<FavoritesProvider>(
                            context,
                            listen: false);
                        if (!favoritesProvider.isFavorite(product.id)) {
                          favoritesProvider.addToFavorites(product);
                        } else {
                          favoritesProvider.removeFromFavorites(product.id);
                        }
                      },
                      icon: Icon(
                        Provider.of<FavoritesProvider>(context)
                                .isFavorite(product.id)
                            ? Icons
                                .favorite // If already in favorites, show filled heart
                            : Icons
                                .favorite_border, // Otherwise, show empty heart
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      // Add your onTap logic here
                    },
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
