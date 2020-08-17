import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    String title,
    double price,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (oldItem) => CartItem(
            id: oldItem.id,
            title: oldItem.title,
            quantity: oldItem.quantity + 1,
            price: oldItem.price,
            imageUrl: oldItem.imageUrl),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price,
            imageUrl: imageUrl),
      );
    }
    notifyListeners();
  }

  void removeItem(productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
