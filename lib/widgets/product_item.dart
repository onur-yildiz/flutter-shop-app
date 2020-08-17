import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // const ProductItem({
  //   Key key,
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  //   this.price,
  // }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  Widget _buildPriceTag(double price, BuildContext context) {
    return Chip(
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          NumberFormat.simpleCurrency(locale: 'tr').format(price),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight
                  .bold), // TODO: this also changes its color, resarch for a way to just change its weight
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
    // return Container(
    //   padding: const EdgeInsets.all(5),
    //   decoration: BoxDecoration(
    //     color: Colors.black87,
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: FittedBox(
    //     fit: BoxFit.scaleDown,
    //     child: Text(
    //       NumberFormat.simpleCurrency(locale: 'tr').format(price),
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: GridTileBar(
          leading: _buildPriceTag(product.price, context),
          title: SizedBox(),
          trailing: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: product.toggleFavoriteStatus,
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
              );
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to the cart.',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
            },
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
