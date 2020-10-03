import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../models/cart_item.dart' as ci;

class CartItem extends StatelessWidget {
  final ci.CartItem cartItem;
  CartItem(this.cartItem);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
        margin: EdgeInsets.all(4),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text(
                  'Are you sure want to delete this product from the cart?'),
              actions: [
                FlatButton(
                  onPressed: () {
                    return Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                FlatButton(
                    onPressed: () {
                      return Navigator.of(context).pop(true);
                    },
                    child: Text('Delete'))
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        Provider.of<CartProvider>(context, listen: false)
            .removeCartItem(cartItem.id);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        elevation: 6,
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text('\$${cartItem.price}'),
              ),
            ),
          ),
          title: Text(
            cartItem.title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Amount : ${cartItem.quantity}'),
        ),
        shadowColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
