import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  const CartItem({
    Key key,
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
  }) : super(key: key);

  Widget buildDismissibleBackground(
      {bool toLeft = false, BuildContext context}) {
    return Container(
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: toLeft ? Alignment.centerRight : Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            size: Theme.of(context).primaryTextTheme.headline4.fontSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: buildDismissibleBackground(context: context),
      secondaryBackground:
          buildDismissibleBackground(toLeft: true, context: context),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              )
            ],
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
                'Total: ${NumberFormat.simpleCurrency(locale: 'tr').format(price * quantity)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
