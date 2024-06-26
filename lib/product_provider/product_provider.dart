import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_app/model/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isProductLoading = true;

  List<Product> bagProducts = [];

  int bagProductscount = 0;

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

  void productInfoInc(Product product) {
    product.productInfoIncValue++;
    notifyListeners();
  }

  void productInfoDec(Product product) {
    if (product.productInfoIncValue > 1) {
     product.productInfoIncValue--;
    }
    notifyListeners();
  }

  void bagProductscountsInc() {
    bagProductscount++;
    notifyListeners();
  }

  void bagProductscountsDec() {
    bagProductscount--;
    notifyListeners();
  }

  void removeProductFromBag(int index) {
    bagProducts.removeAt(index);
    notifyListeners();
  }
}
