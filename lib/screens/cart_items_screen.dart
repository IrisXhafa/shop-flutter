import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartItems extends StatelessWidget {
  static const ROUTE = '/cart-items';
  @override
  Widget build(BuildContext context) {
    CartProvider _cartData = Provider.of<CartProvider>(context);
    OrderProvider _orderData = Provider.of<OrderProvider>(context);
    Map<String, CartItem> _cartItems = _cartData.cartItems;
    var appBar = AppBar(
      title: const Text('Cart Items'),
    );
    final double overallHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              height: overallHeight * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${_cartData.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.button,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      _orderData.addOrder(OrderItem(
                        id: DateTime.now().toString(),
                        totalAmount: _cartData.totalAmount,
                        items: _cartData.cartItems.values.toList(),
                        date: DateTime.now(),
                      ));
                      _cartData.clear();
                    },
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: overallHeight * 0.9,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ci.CartItem(_cartItems.values.toList()[index]);
                },
                itemCount: _cartItems.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ListView.builder(
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: CircleAvatar(
//               child: Text(
//                 _cartItems.values.toList()[index].quantity.toString(),
//               ),
//             ),
//             title: Text(_cartItems.values.toList()[index].title),
//           );
//         },
//         itemCount: _cartItems.length,
//       ),
