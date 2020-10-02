import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_overview_screen.dart';
import 'package:shop_app/screens/products_management_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 6,
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersOverview.ROUTE);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsManagementScreen.ROUTE);
            },
          ),
        ],
      ),
    );
  }
}
