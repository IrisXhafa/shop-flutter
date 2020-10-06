import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/constants.dart';
import '../http_exception.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return [..._items].where((product) => product.isFavorite).toList();
  }

  Product getById(String id) {
    return this.items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts() async {
    var response = await http.get('$URL/products.json');
    var res = json.decode(response.body) as Map<String, dynamic>;
    _items = [];
    res.forEach((key, value) {
      _items.add(_convertMapToProduct(key, value));
    });
    print(json.decode(response.body));
  }

  Future<void> addProduct(Product newProduct) async {
    try {
      Map<String, dynamic> product = _createProductMap(newProduct);
      var response =
          await http.post('$URL/products.json', body: json.encode(product));
      newProduct = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price,
          isFavorite: newProduct.isFavorite);
      this._items.add(newProduct);
      notifyListeners();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(Product editedProduct) async {
    int index = _items.indexWhere((element) => element.id == editedProduct.id);
    if (index >= 0) {
      Product oldProduct = _items[index];
      _items[index] = editedProduct;
      Map<String, dynamic> product = _createProductMap(editedProduct);
      var response = await http.put('$URL/products/${editedProduct.id}.json',
          body: json.encode(product));
      if (response.statusCode >= 400) {
        _items[index] = oldProduct;
        throw HttpException('An error occurred');
      }
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((element) => element.id == id);
    final deletedProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    try {
      final response = await http.delete('$URL/products/$id.json');
      if (response.statusCode >= 400) {
        throw HttpException("Could not delete the product");
      }
    } on Exception catch (e) {
      _handleOnDeleteError(index, deletedProduct);
    }
  }

  _handleOnDeleteError(int index, Product deletedProduct) {
    _items.insert(index, deletedProduct);
    notifyListeners();
    throw HttpException("Could not delete the product");
  }

  _convertMapToProduct(id, productMap) {
    return Product(
        id: id,
        title: productMap['title'],
        description: productMap['description'],
        imageUrl: productMap['imageUrl'],
        price: productMap['price'],
        isFavorite: productMap['isFavorite']);
  }

  _createProductMap(Product product) {
    Map<String, dynamic> productMap = {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite
    };
    return productMap;
  }
}
