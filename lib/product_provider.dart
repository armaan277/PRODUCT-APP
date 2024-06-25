import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_app/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isProductLoading = true;

  Future<void> getProducts() async {
    Response response = await get(Uri.parse('https://dummyjson.com/products'));

    final mapResponse = jsonDecode(response.body);

    final mapResponseList = mapResponse['products'];

    for (int i = 0; i < mapResponseList.length; i++) {
      products.add(Product.fromMap(mapResponseList[i]));
      debugPrint('products : $products');
    }
    isProductLoading = false;
    notifyListeners();
  }

}
