import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/products_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product productData = Provider.of<Product>(context);
    CartProvider cartData = Provider.of<CartProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.ROUTE,
                arguments: productData.id);
          },
          child: Image(
            image: NetworkImage(productData.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              productData.title,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
            ),
            leading: IconButton(
              icon: Icon(productData.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () => productData.toggleFavorite(
                  Provider.of<AuthProvider>(context, listen: false).token,
                  Provider.of<AuthProvider>(context, listen: false).userId),
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                cartData.addCartItem(
                  productId: productData.id,
                  title: productData.title,
                  price: productData.price,
                );
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item added on cart!'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cartData.removeLastAddedItem(productData.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            )),
      ),
    );
  }
}
