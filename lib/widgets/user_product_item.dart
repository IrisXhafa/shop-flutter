import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_form_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(this.title, this.imageUrl, this.id);
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
                  onPressed: () {},
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
