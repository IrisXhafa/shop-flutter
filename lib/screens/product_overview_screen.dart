import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/cart_items_screen.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum MenuItemValues { All, Favorites }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  _getProducts(val) {
    setState(() {
      if (val == MenuItemValues.Favorites) {
        this._showOnlyFavorites = true;
      } else {
        this._showOnlyFavorites = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('Products Overview'),
      actions: [
        PopupMenuButton(
          onSelected: _getProducts,
          itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.border_all),
                  title: Text('Show All'),
                ),
                value: MenuItemValues.All,
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Show Favorites'),
                ),
                value: MenuItemValues.Favorites,
              ),
            ];
          },
          elevation: 4,
          initialValue: MenuItemValues.All,
        )
      ],
    );
    final double overallHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: overallHeight,
        child: ProductsGrid(this._showOnlyFavorites),
      ),
      drawer: MainDrawer(),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(CartItems.ROUTE);
            },
            tooltip: 'Go to cart',
          ),
          Positioned(
            right: 1,
            top: 0,
            child: new Container(
              padding: EdgeInsets.all(4),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).accentColor),
              constraints: BoxConstraints(
                minWidth: 11,
                minHeight: 11,
              ),
              child: Consumer<CartProvider>(
                builder: (context, value, _) {
                  return Text(
                    '${value.cartItems.length}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//
