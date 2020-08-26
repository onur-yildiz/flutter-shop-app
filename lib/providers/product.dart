import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url =
          'https://flutter-app-tutorial-cc123.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
      if (isFavorite) {
        final response = await http.put(
          url,
          body: json.encode(
            isFavorite,
          ),
        );
        if (response.statusCode >= 400) {
          throw 'ERROR_PUT_FAV';
        }
      } else {
        final url =
            'https://flutter-app-tutorial-cc123.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
          throw 'ERROR_DELETE_FAV';
        }
      }
    } catch (e) {
      var errorMessage = 'Something went wrong.';
      switch (e.toString()) {
        case 'ERROR_DELETE_FAV':
          errorMessage = 'Could not delete from favorites.';
          break;
        case 'ERROR_PUT_FAV':
          errorMessage = 'Could not add to favorites';
          break;
        default:
      }
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(errorMessage);
    }
  }
}
