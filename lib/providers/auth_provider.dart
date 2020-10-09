import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expireIn;
  Timer autoLogoutTimer;

  bool isAuthanticated() {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _userId != null &&
        _expireIn.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      var response = await http.post(
        url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );
      var resposeData = json.decode(response.body);
      if (resposeData['error'] != null) {
        throw HttpException(resposeData['error']['message']);
      }
      _token = resposeData['idToken'];
      _userId = resposeData['localId'];
      _expireIn = DateTime.now().add(
        Duration(
          seconds: int.parse(resposeData['expiresIn']),
        ),
      );
      autoLogout();

      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDAI65fZNGZpJNEeGlO6O7tqPnjsUTauX8';
    return _authenticate(email, password, url);
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDAI65fZNGZpJNEeGlO6O7tqPnjsUTauX8';
    return _authenticate(email, password, url);
  }

  logout() {
    _token = null;
    _userId = null;
    _expireIn = null;
    if (autoLogoutTimer != null) {
      autoLogoutTimer.cancel();
      autoLogoutTimer = null;
    }
    notifyListeners();
  }

  autoLogout() {
    if (autoLogoutTimer != null) {
      autoLogoutTimer.cancel();
    }
    final difference = _expireIn.difference(DateTime.now()).inSeconds;
    autoLogoutTimer = Timer(Duration(seconds: difference), logout);
  }
}
