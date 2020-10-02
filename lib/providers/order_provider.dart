import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  addOrder(OrderItem order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}
