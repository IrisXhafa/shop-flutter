import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersOverview extends StatelessWidget {
  static const String ROUTE = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
            future: Provider.of<OrderProvider>(context).fetchOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<OrderProvider>(
                  builder: (ctx, orderData, _) {
                    return Container(
                      child: ListView.builder(
                        itemBuilder: (_, index) =>
                            OrderItem(orderData.orders[index]),
                        itemCount: orderData.orders.length,
                      ),
                    );
                  },
                );
              }
            }));
  }
}
