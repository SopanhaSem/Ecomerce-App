import 'package:ecomerces/src/model/fav_product.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}
