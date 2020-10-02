import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const ROUTE = 'product-details';
  ProductDetailsScreen();

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    Product selectedProduct =
        Provider.of<ProductsProvider>(context).getById(id);
    final AppBar appBar = AppBar(title: Text(selectedProduct.title));
    final overallHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: overallHeight * 0.3,
            width: double.infinity,
            child: Image(
              image: NetworkImage(selectedProduct.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: overallHeight * 0.03,
          ),
          Container(
            height: overallHeight * 0.05,
            child: Text(
              selectedProduct.title,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: overallHeight * 0.03,
          ),
          Container(
            height: overallHeight * 0.5,
            child: Text(
              selectedProduct.description,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
