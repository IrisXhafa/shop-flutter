import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductFormScreen extends StatefulWidget {
  static const ROUTE = 'product-edit';

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();

  final TextEditingController _imageUrlTextFieldController =
      TextEditingController();

  Product newProduct = Product(
      id: null, title: null, description: null, imageUrl: null, price: null);

  @override
  initState() {
    this._imageUrlFocusNode.addListener(_updateImagePreview);
    super.initState();
  }

  @override
  dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    _imageUrlTextFieldController.dispose();
    super.dispose();
  }

  bool _validateUrl(String url) {
    return RegExp('/([a-z\-_0-9\/\:\.]*\.(jpg|jpeg|png|gif))',
            caseSensitive: false, multiLine: false)
        .hasMatch(url);
  }

  _updateImagePreview() {
    if (!_imageUrlFocusNode.hasFocus &&
        _validateUrl(_imageUrlTextFieldController.text)) {
      this.setState(() {});
    }
  }

  _saveProduct() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    this._formKey.currentState.save();
    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(newProduct);
    Navigator.of(context).pop();
  }

  _changeFocusScope(FocusNode nextFocusNode) {
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveProduct)],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _changeFocusScope(_priceFocusNode),
                onSaved: (value) {
                  newProduct = Product(
                      id: newProduct.id,
                      title: value,
                      description: newProduct.description,
                      imageUrl: newProduct.imageUrl,
                      price: newProduct.price);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                focusNode: _priceFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    _changeFocusScope(_descriptionFocusNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be bigger than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  newProduct = Product(
                    id: newProduct.id,
                    title: newProduct.title,
                    description: newProduct.description,
                    imageUrl: newProduct.imageUrl,
                    price: double.parse(value),
                  );
                },
              ),
              TextFormField(
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value.length <= 5) {
                    return 'Please enter a longer description';
                  }
                  return null;
                },
                onSaved: (value) {
                  newProduct = Product(
                    id: newProduct.id,
                    title: newProduct.title,
                    description: value,
                    imageUrl: newProduct.imageUrl,
                    price: newProduct.price,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0, 6, 5, 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlTextFieldController.text.isEmpty
                          ? Text(
                              'Enter URL',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          : FittedBox(
                              child: Image.network(
                                  _imageUrlTextFieldController.text),
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlTextFieldController,
                      decoration: InputDecoration(labelText: 'ImageUrl'),
                      focusNode: _imageUrlFocusNode,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (!_validateUrl(value)) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        newProduct = Product(
                          id: newProduct.id,
                          title: newProduct.title,
                          description: newProduct.description,
                          imageUrl: value,
                          price: newProduct.price,
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
