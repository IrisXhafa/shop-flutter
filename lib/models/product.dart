import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/http_exception.dart';

import '../constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String creatorId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.creatorId,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final bool oldStatus = this.isFavorite;
    try {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      var response = await http.put(
        '$URL/usersfavorites/$userId/$id.json?auth=$token',
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        this.isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('An error occurred');
      }
    } on Exception catch (e) {
      this.isFavorite = oldStatus;
      notifyListeners();
      throw e;
    }
  }
}
