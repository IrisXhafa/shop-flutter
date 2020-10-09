import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/product_form_screen.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class ProductsManagementScreen extends StatelessWidget {
  static const ROUTE = '/products-management';
  AppBar _appBar;

  _createAppBar(BuildContext context) {
    _appBar = AppBar(
      title: Text('Product Management'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(ProductFormScreen.ROUTE);
          },
        )
      ],
    );
    return _appBar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      drawer: MainDrawer(),
      body: Container(
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              _appBar.preferredSize.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: Provider.of<ProductsProvider>(context).fetchProducts(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<ProductsProvider>(
                  builder: (ctx, productsData, _) {
                    return ListView.builder(
                      itemBuilder: (ctx, index) {
                        Product product = productsData.items[index];
                        return UserProductItem(
                          product.title,
                          product.imageUrl,
                          product.id,
                          productsData.deleteProduct,
                        );
                      },
                      itemCount: productsData.items.length,
                    );
                  },
                );
              }
            },
          )),
    );
  }
}
