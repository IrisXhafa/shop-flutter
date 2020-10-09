import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';

enum ScreenType { LOGIN, SIGNUP }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  ScreenType screenType;

  final _passwordFocusNode = new FocusNode();

  final _passwordConfirmFocusNode = new FocusNode();

  final _passwordFieldController = new TextEditingController();

  AuthProvider authProvider;

  @override
  initState() {
    setState(() {
      screenType = ScreenType.LOGIN;
    });
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    super.initState();
  }

  Map<String, String> formData = {
    'email': '',
    'password': '',
  };

  _submit() async {
    _formKey.currentState.save();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (screenType == ScreenType.SIGNUP) {
      await authProvider.signUp(
        formData['email'].trim(),
        formData['password'].trim(),
      );
    } else {
      await authProvider.login(
        formData['email'].trim(),
        formData['password'].trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange[50],
              Colors.deepOrange[400],
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              transform: Matrix4.rotationZ(-6)..translate(0.0, -50.0, 50.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'MY SHOP',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 30,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              color: Colors.deepOrangeAccent[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white70),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        onSaved: (newValue) => formData['email'] = newValue,
                      ),
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordFieldController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        validator: (value) {
                          if (value.length < 5) {
                            return 'Password should contain at least 5 characters';
                          }
                          return null;
                        },
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordConfirmFocusNode),
                        onSaved: (newValue) => formData['password'] = newValue,
                      ),
                      if (screenType == ScreenType.SIGNUP)
                        TextFormField(
                          focusNode: _passwordConfirmFocusNode,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.send,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value != _passwordFieldController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      Row(
                        children: [
                          RaisedButton(
                            visualDensity: VisualDensity.comfortable,
                            onPressed: _submit,
                            child: Text(screenType == ScreenType.SIGNUP
                                ? 'Sign Up'
                                : 'Login'),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            textTheme: ButtonTextTheme.primary,
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                if (screenType == ScreenType.LOGIN) {
                                  screenType = ScreenType.SIGNUP;
                                } else {
                                  screenType = ScreenType.LOGIN;
                                }
                              });
                            },
                            child: Text(
                              screenType == ScreenType.SIGNUP
                                  ? 'Already registered? Login!'
                                  : 'Create an account',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
