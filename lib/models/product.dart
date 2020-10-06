import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/http_exception.dart';

import '../constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final bool oldStatus = this.isFavorite;
    try {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      var response = await http.patch(
        '$URL/products/$id.json',
        body: json.encode(
          {'isFavorite': !isFavorite},
        ),
      );
      if (response.statusCode >= 400) {
        this.isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('An error occurred');
      }
    } on Exception catch (e) {
      this.isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
