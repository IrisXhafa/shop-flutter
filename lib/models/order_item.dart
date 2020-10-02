import 'package:shop_app/models/cart_item.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<CartItem> items;
  final DateTime date;

  OrderItem({
    this.items,
    this.totalAmount,
    this.date,
    this.id,
  });
}
