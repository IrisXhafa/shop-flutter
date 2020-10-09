import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  CartProvider(this._token, this._cartItems);
  String _token;
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  double get totalAmount {
    var _totalAmount = 0.0;
    _cartItems.forEach((key, value) {
      _totalAmount += (value.price * value.quantity);
    });
    return _totalAmount;
  }

  addCartItem({
    @required String productId,
    @required String title,
    @required double price,
  }) {
    if (_cartItems.containsKey(productId)) {
      _updateCartItem(productId);
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  _updateCartItem(String productId) {
    _cartItems.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
    );
    notifyListeners();
  }

  removeCartItem(String id) {
    _cartItems.removeWhere((key, value) => value.id == id);
    notifyListeners();
  }

  removeLastAddedItem(String id) {
    if (_cartItems[id].quantity > 1) {
      _cartItems.update(
          id,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1));
    } else {
      _cartItems.removeWhere((key, _) => key == id);
    }
    notifyListeners();
  }

  clear() {
    _cartItems = {};
    notifyListeners();
  }
}
