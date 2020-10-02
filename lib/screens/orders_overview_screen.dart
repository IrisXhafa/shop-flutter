import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order_item.dart' as i;
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersOverview extends StatelessWidget {
  static const String ROUTE = '/orders';
  @override
  Widget build(BuildContext context) {
    var _orderData = Provider.of<OrderProvider>(context);
    List<i.OrderItem> _ordersList = _orderData.orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: ListView.builder(
          itemBuilder: (_, index) => OrderItem(_ordersList[index]),
          itemCount: _ordersList.length,
        ),
      ),
    );
  }
}
