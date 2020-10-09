import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_items_screen.dart';
import 'package:shop_app/screens/orders_overview_screen.dart';
import 'package:shop_app/screens/product_form_screen.dart';
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            update: (context, authData, previousProducts) => ProductsProvider(
                authData.token,
                authData.userId,
                previousProducts == null ? [] : previousProducts.items),
            create: null),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          update: (context, authData, previousCartItems) => CartProvider(
              authData.token,
              previousCartItems == null ? {} : previousCartItems.cartItems),
          create: null,
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (context, authData, previousOrders) => OrderProvider(
              authData.token,
              authData.userId,
              previousOrders == null ? [] : previousOrders.orders),
          create: null,
        ),
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
        home: Consumer<AuthProvider>(
          builder: (context, authData, _) {
            return authData.isAuthanticated()
                ? ProductOverviewScreen()
                : AuthScreen();
          },
        ),
        routes: {
          ProductDetailsScreen.ROUTE: (context) => ProductDetailsScreen(),
          CartItems.ROUTE: (context) => CartItems(),
          OrdersOverview.ROUTE: (context) => OrdersOverview(),
          ProductsManagementScreen.ROUTE: (context) =>
              ProductsManagementScreen(),
          ProductFormScreen.ROUTE: (context) => ProductFormScreen(),
        },
      ),
    );
  }
}
