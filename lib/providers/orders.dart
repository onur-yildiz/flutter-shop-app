import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.price,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-app-tutorial-cc123.firebaseio.com/orders.json';
    final List<OrderItem> loadedOrders = [];
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _orders = [];
        notifyListeners();
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            price: orderData['price'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                    imageUrl: item['imageUrl'],
                  ),
                )
                .toList(),
          ),
        );
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      });
    } catch (e) {
      print(e);
      throw HttpException('Could not fetch orders.');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-app-tutorial-cc123.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    if (cartProducts.isEmpty) {
      return;
    }

    notifyListeners();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'price': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price,
                    'imageUrl': product.imageUrl,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          price: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
    } catch (e) {
      print(e);
      throw HttpException('Could not add cart items to the orders.');
    }
  }
}
