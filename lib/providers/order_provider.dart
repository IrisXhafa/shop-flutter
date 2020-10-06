import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';

import 'package:shop_app/models/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    var response = await http.get('$URL/orders.json');
    this._orders = json.decode(response.body);
  }

  Future<void> addOrder(OrderItem order) async {
    var response = await http.post('$URL/orders.json',
        body: json.encode(_createOrderMap(order)));
    _orders.insert(0, json.decode(response.body));
    notifyListeners();
    return response;
  }

  _createOrderMap(OrderItem order) {
    return {
      'id': order.id,
      'totalAmount': order.totalAmount,
      'items': order.items,
      'date': order.date.toIso8601String()
    };
  }
}
