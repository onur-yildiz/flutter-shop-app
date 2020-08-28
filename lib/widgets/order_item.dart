import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_shop_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                NumberFormat.simpleCurrency(locale: 'tr').format(widget.order.price),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            // if (_expanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: _expanded ? min(widget.order.products.length * 20.0 + 10, 100) : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              // height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: Theme.of(context).textTheme.subtitle1.apply(fontWeightDelta: 2),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.order.products[i].quantity}x',
                          style: Theme.of(context).textTheme.subtitle1.apply(fontWeightDelta: 2),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            '${NumberFormat.simpleCurrency(locale: 'tr').format(widget.order.products[i].price)}'),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
