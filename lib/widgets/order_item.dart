import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/order_item.dart' as i;

class OrderItem extends StatefulWidget {
  final i.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text('\$${widget.order.totalAmount.toStringAsFixed(2)}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  this._isExpanded = !this._isExpanded;
                });
              },
            ),
          ),
        ),
        if (this._isExpanded)
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: min(widget.order.items.length * 20.00 + 15, 100),
            child: ListView(
              children: widget.order.items.map((prod) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${prod.title}',
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text('${prod.quantity} * \$${prod.price}')
                  ],
                );
              }).toList(),
            ),
          )
      ],
    );
  }
}
