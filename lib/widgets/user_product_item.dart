import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_form_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final Function deleteProduct;

  UserProductItem(this.title, this.imageUrl, this.id, this.deleteProduct);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ProductFormScreen.ROUTE, arguments: this.id);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Container(
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Delete product $title",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        content:
                            Text('Are you sure you want to delete $title ?'),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          FlatButton(
                            onPressed: () {
                              this.deleteProduct(id);
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          )
                        ],
                        actionsOverflowDirection: VerticalDirection.down,
                        titlePadding: EdgeInsets.all(4),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
