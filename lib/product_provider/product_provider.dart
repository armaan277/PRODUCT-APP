import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/config/endponts.dart';
import 'package:shopping_app/main.dart';
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

  List<dynamic> cartResponse = [];

  bool isAddressStoreInDatabase = false;

  Future<void> getProducts() async {
    // Response response = await get(Uri.parse('https://dummyjson.com/products?limit=194'));

    http.Response response =
        await http.get(Uri.parse(Endponts.allProductsEndPoint));

    final mapResponse = jsonDecode(response.body);

    debugPrint('mapResponse : $mapResponse');

    for (int i = 0; i < mapResponse.length; i++) {
      products.add(Product.fromMap(mapResponse[i]));
    }
    isProductLoading = false;
    // getSFProducts();
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

  // void bagProductscountsInc() {
  //   bagProductsCount++;
  //   setSFProducts();
  //   notifyListeners();
  // }

  // void bagProductscountsDec() {
  //   bagProductsCount--;
  //   setSFProducts();
  //   notifyListeners();
  // }

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

  // void favoriteProduct(Product product) async {
  //   if (!favoriteProducts.contains(product)) {
  //     favoriteProducts.add(product);
  //   } else {
  //     favoriteProducts.remove(product);
  //   }
  //   setSFProducts();
  //   notifyListeners();
  // }

  void setSFProducts() async {
    final prefs = await SharedPreferences.getInstance();

    // final jsonFavoriteProduct =
    //     favoriteProducts.map((p) => p.toJson()).toList();
    // final jsonBagProducts = bagProducts.map((p) => p.toJson()).toList();
    // debugPrint('jsonFavoriteProduct : $jsonFavoriteProduct');
    // prefs.setStringList('favorite', jsonFavoriteProduct);
    // prefs.setStringList('bag', jsonBagProducts);
    // prefs.setInt('bagProCount', bagProductsCount);
    prefs.setDouble('total', totalPrice);

    // prefs.setString('name', nameController.text);
    // prefs.setString('address', addressController.text);
    // prefs.setString('city', cityController.text);
    // prefs.setString('state', stateController.text);
    // prefs.setString('zipcode', zipcodeController.text);
    // prefs.setString('country', countryController.text);
  }

  void getSFProducts() async {
    final prefs = await SharedPreferences.getInstance();
    // final List<String>? jsonFavoriteProduct = prefs.getStringList('favorite');
    // final List<String>? jsonBagProducts = prefs.getStringList('bag');

    // favoriteProducts =
    //     jsonFavoriteProduct?.map((json) => Product.fromJson(json)).toList() ??
    //         [];
    // bagProducts =
    //     jsonBagProducts?.map((json) => Product.fromJson(json)).toList() ?? [];
    // bagProductsCount = prefs.getInt('bagProCount') ?? 0;
    totalPrice = prefs.getDouble('total') ?? 0.0;

    // nameController.text = prefs.getString('name') ?? '';
    // addressController.text = prefs.getString('address') ?? '';
    // cityController.text = prefs.getString('city') ?? '';
    // stateController.text = prefs.getString('state') ?? '';
    // zipcodeController.text = prefs.getString('zipcode') ?? '';
    // countryController.text = prefs.getString('country') ?? '';
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

// FAVORITE API WORK
  Future<void> toggleFavoriteStatus(Product favoriteProduct) async {
    if (!favoriteProducts.contains(favoriteProduct)) {
      // Add to favorites
      await postFavoriteData(favoriteProduct);
    } else {
      // Remove from favorites
      await deleteFavouriteData(favoriteProduct.id);
    }

    notifyListeners();
  }

  void getFavouriteData(String userId) async {
    final url = Uri.parse('http://192.168.0.111:3000/favorite/$userId');
    final response = await http.get(url);

    debugPrint('favouriteResponse : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> favouriteResponse = jsonDecode(response.body);

      // Map the response to a List<Product>
      favoriteProducts = favouriteResponse
          .map((favoritePro) => Product.fromMap(favoritePro))
          .toList();
      isProductLoading = false;
      notifyListeners();

      debugPrint('favoriteProducts: $favoriteProducts');
    } else {
      debugPrint('Failed to load data');
    }
  }

  Future<void> postFavoriteData(Product favoriteProduct) async {
    final url = Uri.parse('http://192.168.0.111:3000/favorite');

    Map<String, dynamic> postFavorite = {
      'id': favoriteProduct.id,
      'favourite_products_id': userUniqueId, // Replace with actual user ID
      'thumbnail': favoriteProduct.thumbnail,
      'title': favoriteProduct.title,
      'brand': favoriteProduct.brand,
      'price': favoriteProduct.price,
      'rating': favoriteProduct.rating,
      'warrantyinformation': favoriteProduct.warrantyInformation,
      'category' : favoriteProduct.category,
    };

    try {
      if (!favoriteProducts.contains(favoriteProduct)) {
        // Add to favorites
        final response = await http.post(
          url,
          body: jsonEncode(postFavorite),
          headers: {'Content-Type': 'application/json'},
        );

        debugPrint('responseFavorite : ${response.body}');
        if (response.statusCode == 201) {
          favoriteProducts.add(favoriteProduct);
        } else {
          debugPrint('Failed to add favorite: ${response.body}');
        }
      } else {
        // Remove from favorites
        await deleteFavouriteData(favoriteProduct.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error posting favorite: $e');
    }
  }

  Future<void> deleteFavouriteData(int id) async {
    final url = Uri.parse('http://192.168.0.111:3000/favorite/$id');

    try {
      final response = await http.delete(url);

      debugPrint('deleteFavouriteResponse : ${response.body}');
      if (response.statusCode == 200) {
        favoriteProducts.removeWhere((product) => product.id == id);
        notifyListeners();
      } else {
        debugPrint('Failed to delete favorite: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting favorite: $e');
    }
  }

  // CART API WORK
  void postCartData(Product bagProducts) {
    final url = Uri.parse('http://192.168.0.111:3000/cartproducts');

    final newTodo = {
      'id': userUniqueId,
      'thumbnail': bagProducts.thumbnail,
      'title': bagProducts.title,
      'brand': bagProducts.brand,
      'price': bagProducts.price,
      'cart_product_id': bagProducts.id,
    };

    http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newTodo),
    );

    notifyListeners();
  }

  void getCartsData(String userId) async {
    final url = Uri.parse('http://192.168.0.111:3000/cartproducts/$userId');
    final response = await http.get(url);
    debugPrint('cartResponse: ${response.body}');

    if (response.statusCode == 200) {
      cartResponse = jsonDecode(response.body);
      debugPrint('cartResponse : $cartResponse');

      // Map the response to a List<Product>
      bagProducts =
          cartResponse.map((cartPro) => Product.fromMap(cartPro)).toList();
      isProductLoading = false;
      notifyListeners();

      // Debugging purpose: Print all cart product IDs
      for (var product in cartResponse) {
        debugPrint('Cart Product ID: ${product['cart_product_id']}');
      }
    } else {
      debugPrint('Failed to load data');
    }
  }

  void deleteCartData(int id) async {
    final url = Uri.parse('http://192.168.0.111:3000/cartproducts/$id');

    try {
      final response = await http.delete(url);
      debugPrint('deleteCartResponse: ${response.body}');

      if (response.statusCode == 200) {
        // Remove the item from cartResponse after successful deletion
        cartResponse.removeWhere((product) => product['cart_product_id'] == id);
        debugPrint('cartResponse after deletion: $cartResponse');

        // Optionally, remove from bagProducts (UI list)
        bagProducts.removeWhere((product) => product.id == id);

        // Notify listeners to update the UI
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
    }
  }

  // ADDRESS API WORK
  Future<void> getAddressData(String userId) async {
    final url = Uri.parse('http://192.168.0.111:3000/address/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.isNotEmpty) {
          // Populate the text controllers with existing data
          nameController.text = responseBody[0]['full_name'] ?? '';
          addressController.text = responseBody[0]['address'] ?? '';
          cityController.text = responseBody[0]['city'] ?? '';
          stateController.text = responseBody[0]['state_region'] ?? '';
          zipcodeController.text =
              responseBody[0]['zip_code']?.toString() ?? '';
          countryController.text = responseBody[0]['country'] ?? '';

          // Address is available in the database
          isAddressStoreInDatabase = true;
          notifyListeners();
          debugPrint('Address data successfully loaded.');
        } else {
          // Address not available
          isAddressStoreInDatabase = false;
          debugPrint('No address data found.');
        }
      } else if (response.statusCode == 404) {
        // Address not available
        isAddressStoreInDatabase = false;
        debugPrint('ADDRESS NOT AVAILABLE !!!');
      } else {
        debugPrint('Unexpected response: ${response.statusCode}');
      }
      notifyListeners(); // Update the UI based on the flag
    } catch (e) {
      debugPrint('Error occurred: $e');
    }
  }

  void postAddressData() async {
    final url = Uri.parse('http://192.168.0.111:3000/address');

    final postAddressData = {
      'address_id': userUniqueId,
      'full_name': nameController.text,
      'address': addressController.text,
      'city': cityController.text,
      'state_region': stateController.text,
      'zip_code': zipcodeController.text,
      'country': countryController.text,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postAddressData),
    );
    notifyListeners();
    debugPrint('response : ${response.body}');
  }

  void addressUpdate(
    String userId,
    String fullName,
    String address,
    String city,
    String stateRegion,
    int zipCode,
    String country,
  ) {
    final url = Uri.parse('http://192.168.0.111:3000/address/$userId');

    final updatedTodo = jsonEncode({
      'address_id': userId,
      'full_name': fullName,
      'address': address,
      'city': city,
      'state_region': stateRegion,
      'zip_code': zipCode,
      'country': country,
    });

    http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: updatedTodo,
    );
    notifyListeners();
  }

  void postAddressId(String userId) async {
    final url = Uri.parse('http://192.168.0.111:3000/orderslist/$userId');

    final data = {
      'address_id': userId,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    final orderCreatedResponse = jsonDecode(response.body);

    debugPrint('Order response : ${orderCreatedResponse['message']}');
    if (orderCreatedResponse['message'] == "Order Created Successfully") {
      deleteOrderCartProducts(userUniqueId);
      notifyListeners();
    }
  }

  void deleteOrderCartProducts(String userId) async {
    final url =
        Uri.parse('http://192.168.0.111:3000/ordercartproducts/$userId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        debugPrint('Delete successful: ${response.body}');
        notifyListeners();
      } else if (response.statusCode == 404) {
        debugPrint('Delete failed: No record found with the given ID');
      } else {
        debugPrint('Delete failed: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      debugPrint('Error during delete: $e');
    }
  }

  // void postSignUp(String userId) async {
  //   final url = Uri.parse('http://192.168.0.111:3000/bookingcarts/$userId');

  //   final data = {
  //     'id': userId,
  //   };

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(data),
  //   );

  //   debugPrint('response : ${response.body}');
  // }
}
