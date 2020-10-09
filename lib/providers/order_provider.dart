import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/cart_item.dart';

import 'package:shop_app/models/order_item.dart';

class OrderProvider with ChangeNotifier {
  OrderProvider(this._token, this._userId, this._orders);
  final String _userId;
  final String _token;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    var response = await http.get('$URL/orders/$_userId.json?auth=$_token');
    _orders = [];
    _setOrders(json.decode(response.body));
  }

  _setOrders(Map<String, dynamic> mappedOrders) {
    mappedOrders.forEach((orderId, orderData) {
      _orders.add(
        OrderItem(
          id: orderId,
          totalAmount: orderData['totalAmount'],
          items: (orderData['items'] as List<dynamic>).map(
            (item) {
              return CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
              );
            },
          ).toList(),
          date: DateTime.parse(orderData['date']),
        ),
      );
    });
  }

  Future<void> addOrder(OrderItem order) async {
    var response = await http.post('$URL/orders/$_userId.json?auth=$_token',
        body: json.encode(_createOrderMap(order)));
    print(response);
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            totalAmount: order.totalAmount,
            date: order.date,
            items: order.items));
    notifyListeners();
  }

  _createOrderMap(OrderItem order) {
    final cartMap = {
      'id': null,
      'totalAmount': order.totalAmount,
      'items': order.items
          .map((item) => {
                'id': null,
                'title': item.title,
                'price': item.price,
                'quantity': item.quantity
              })
          .toList(),
      'date': order.date.toIso8601String()
    };

    return cartMap;
  }
}
