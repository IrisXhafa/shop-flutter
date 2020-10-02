import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_items_screen.dart';
import 'package:shop_app/screens/orders_overview_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/products_details_screen.dart';
import 'package:shop_app/screens/products_management_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrangeAccent,
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
              ),
              button: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
              )),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailsScreen.ROUTE: (context) => ProductDetailsScreen(),
          CartItems.ROUTE: (context) => CartItems(),
          OrdersOverview.ROUTE: (context) => OrdersOverview(),
          ProductsManagementScreen.ROUTE: (context) =>
              ProductsManagementScreen()
        },
      ),
    );
  }
}
