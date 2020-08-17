import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/providers/cart.dart' show Cart;
import 'package:flutter_shop_app/widgets/cart_item.dart';
import 'package:flutter_shop_app/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      NumberFormat.simpleCurrency(locale: 'tr')
                          .format(cart.totalPrice),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  FlatButton(
                    splashColor: Theme.of(context).primaryColor.withOpacity(.5),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalPrice,
                      );
                      cart.clear();
                    },
                    child: Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
                imageUrl: cart.items.values.toList()[i].imageUrl,
              ),
            ),
          )
        ],
      ),
    );
  }
}
