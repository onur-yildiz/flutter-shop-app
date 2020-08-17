import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.deepOrange,
          textTheme: ThemeData.light().textTheme.copyWith(
              // headline6: TextStyle(
              //   color: Colors.white,
              // ),
              ),
          // primaryIconTheme: IconThemeData(color: Colors.white),
          // primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
          //       bodyColor: Colors.white,
          //       displayColor: Colors.red,
          //     ),
          //TODO: LOOK MORE INTO THEME-ING
          // iconTheme: IconThemeData(size: ),
          fontFamily: 'Lato',
        ),
        // home: ProductsOverviewScreen(),
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
