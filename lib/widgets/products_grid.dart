import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Provider.of<ProductsProvider>(context).fetchProducts(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.connectionState == ConnectionState.done) {
            return Consumer<ProductsProvider>(builder: (ctx, productsData, _) {
              List<Product> products;
              if (this.showOnlyFavorites) {
                products = productsData.favorites;
              } else {
                products = productsData.items;
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, index) {
                  return ChangeNotifierProvider.value(
                    value: products[index],
                    builder: (context, child) => ProductItem(),
                  );
                },
                itemCount: products.length,
              );
            });
          } else {
            return Text('Error occurred');
          }
        },
      ),
    );
  }
}
