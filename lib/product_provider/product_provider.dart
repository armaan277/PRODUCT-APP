import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/config/endponts.dart';
import 'package:shopping_app/model/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [];

  bool isProductLoading = true;

  List<Product> bagProducts = [];

  List<Product> favoriteProducts = [];

  int bagProductsCount = 0;

  String selectFavoriteCategories = '';

  String selectSize = '';

  String selectFilterationFavorite = 'No Filters';

  String selectFilterationShop = 'No Filters';

  String selectShopCategories = '';

  TextEditingController searchController = TextEditingController();

  double totalPrice = 0.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  Future<void> getProducts() async {
    // Response response = await get(Uri.parse('https://dummyjson.com/products?limit=194'));

    http.Response response = await http.get(Uri.parse(Endponts.allProductsEndPoint));

    final mapResponse = jsonDecode(response.body);

    debugPrint('mapResponse : $mapResponse');

    for (int i = 0; i < mapResponse.length; i++) {
      products.add(Product.fromMap(mapResponse[i]));
    }
    isProductLoading = false;
    getSFProducts();
    notifyListeners();
  }

void productInfoInc(Product product) {
  product.productInfoIncValue++;
  totalPrice = totalPrice + product.price;
  setSFProducts();
  notifyListeners();
}

void productInfoDec(Product product) {
  if (product.productInfoIncValue > 1) {
    product.productInfoIncValue--;
    totalPrice = totalPrice - product.price;
    setSFProducts();
  }
  notifyListeners();
}


  void bagProductscountsInc() {
    bagProductsCount++;
    setSFProducts();
    notifyListeners();
  }

  void bagProductscountsDec() {
    bagProductsCount--;
    setSFProducts();
    notifyListeners();
  }

  void removeProductFromBag(int index) {
    bagProducts.removeAt(index);
    setSFProducts();
    totalPriceBagItems();
    notifyListeners();
  }

  void removeProductFromFavorite(Product product) {
    favoriteProducts.removeWhere((ele) => ele.id == product.id);
    setSFProducts();
    notifyListeners();
  }

  void favoriteProduct(Product product) async {
    if (!favoriteProducts.contains(product)) {
      favoriteProducts.add(product);
    } else {
      favoriteProducts.remove(product);
    }
    setSFProducts();
    notifyListeners();
  }

  void setSFProducts() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonFavoriteProduct = favoriteProducts.map((p) => p.toJson()).toList();
    final jsonBagProducts = bagProducts.map((p) => p.toJson()).toList();
    debugPrint('jsonFavoriteProduct : $jsonFavoriteProduct');
    prefs.setStringList('favorite', jsonFavoriteProduct);
    prefs.setStringList('bag', jsonBagProducts);
    prefs.setInt('bagProCount', bagProductsCount);
    prefs.setDouble('total', totalPrice);

    prefs.setString('name', nameController.text);
    prefs.setString('address', addressController.text);
    prefs.setString('city', cityController.text);
    prefs.setString('state', stateController.text);
    prefs.setString('zipcode', zipcodeController.text);
    prefs.setString('country', countryController.text);
  }

  void getSFProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonFavoriteProduct = prefs.getStringList('favorite');
    final List<String>? jsonBagProducts = prefs.getStringList('bag');

    favoriteProducts = jsonFavoriteProduct?.map((json) => Product.fromJson(json)).toList() ?? [];
    bagProducts = jsonBagProducts?.map((json) => Product.fromJson(json)).toList() ?? [];
    bagProductsCount = prefs.getInt('bagProCount') ?? 0;
    totalPrice = prefs.getDouble('total') ?? 0.0;

    nameController.text = prefs.getString('name') ?? '';
    addressController.text = prefs.getString('address') ?? '';
    cityController.text = prefs.getString('city') ?? '';
    stateController.text = prefs.getString('state') ?? '';
    zipcodeController.text = prefs.getString('zipcode') ?? '';
    countryController.text = prefs.getString('country') ?? '';

  }

  void favoriteChip(String favoriteChip) {
    selectFavoriteCategories = favoriteChip;
    notifyListeners();
  }

  void shopChip(String shopChip) {
    selectShopCategories = shopChip;
    notifyListeners();
  }

  void selectSizes(String newSize) {
    selectSize = newSize;
    notifyListeners();
  }

  void selectFilterationsFavorite(String newSelectFilteration) {
    selectFilterationFavorite = newSelectFilteration;
    notifyListeners();
  }

  void selectFilterationsShop(String newSelectFilterationShop) {
    selectFilterationShop = newSelectFilterationShop;
    notifyListeners();
  }

  void sortProductsByPriceHighToLow(List<Product> productSort) {
    for (int i = 0; i < productSort.length - 1; i++) {
      for (int j = 0; j < productSort.length - i - 1; j++) {
        if (productSort[j].price < productSort[j + 1].price) {
          Product temp = productSort[j];
          productSort[j] = productSort[j + 1];
          productSort[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void sortProductsByPriceLowToHigh(List<Product> productSort) {
    for (int i = 0; i < productSort.length - 1; i++) {
      for (int j = 0; j < productSort.length - i - 1; j++) {
        if (productSort[j].price > productSort[j + 1].price) {
          Product temp = productSort[j];
          productSort[j] = productSort[j + 1];
          productSort[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void sortProductsByBestRating(List<Product> productSort) {
    for (int i = 0; i < productSort.length - 1; i++) {
      for (int j = 0; j < productSort.length - i - 1; j++) {
        if (productSort[j].rating < productSort[j + 1].rating) {
          Product temp = productSort[j];
          productSort[j] = productSort[j + 1];
          productSort[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void filterProducts(String value) {
    products.where((ele) {
      return ele.title.toLowerCase().contains(value.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void cancelSearching() {
    searchController.clear();
    notifyListeners();
  }

  void totalPriceBagItems() {
    totalPrice = bagProducts.fold(0.0, (total, cur) => total + cur.price);
    getSFProducts();
    debugPrint('Total Price: $totalPrice');
  }
}
