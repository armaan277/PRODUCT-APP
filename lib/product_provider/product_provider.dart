import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/config/endponts.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import 'package:shopping_app/widgets/bottom_navigation_bar.dart';

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

  bool isAddressStoreInDatabase = false;

  // Orders Details Variable
  List<dynamic> orders = [];
  bool isLoadingOrderDetails = true;

  // Orders List Variable
  List<dynamic> orderItems = [];
  bool isLoadingOrderList = true;
  String errorMessage = '';

  // Login TextContreller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> getProducts() async {
    final response = await http.get(Uri.parse(Endponts.allProductsEndPoint));

    final mapResponse = jsonDecode(response.body);

    debugPrint('mapResponse : $mapResponse');

    for (int i = 0; i < mapResponse.length; i++) {
      products.add(Product.fromMap(mapResponse[i]));
    }
    isProductLoading = false;
    notifyListeners();
  }

  void productInfoInc(Product product) {
    product.quantity++;
    debugPrint('product.quantity++ increament : ${product.quantity}');
    // totalPrice = totalPrice + product.price;
    notifyListeners();
  }

  void productInfoDec(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
      debugPrint('product.quantity-- decreament : ${product.quantity}');
      // totalPrice = totalPrice - product.price;
      notifyListeners();
    }
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

  void setSFProducts() async {
    final prefs = await SharedPreferences.getInstance();

    // final jsonFavoriteProduct =
    //     favoriteProducts.map((p) => p.toJson()).toList();
    // final jsonBagProducts = bagProducts.map((p) => p.toJson()).toList();
    // debugPrint('jsonFavoriteProduct : $jsonFavoriteProduct');
    // prefs.setStringList('favorite', jsonFavoriteProduct);
    // prefs.setStringList('bag', jsonBagProducts);
    // prefs.setInt('bagProCount', bagProductsCount);
    // prefs.setDouble('total', totalPrice);

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
    // totalPrice = prefs.getDouble('total') ?? 0.0;

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

// LOGIN WORK
  void postLoginData(BuildContext context) async {
    final url = Uri.parse('http://192.168.0.111:3000/login');

    final loginData = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    final signUpResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      userUniqueId = signUpResponse['user']['id'] ?? '';
      debugPrint('userUniqueId : $userUniqueId');

      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool('isLoggedIn', true);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      );
    } else if (response.statusCode == 401) {
      errorMessage = 'Invalid email or password!';
      notifyListeners();
    }
  }

// FAVORITE API WORK
  Future<void> toggleFavoriteStatus(Product favoriteProduct) async {
    if (!favoriteProducts.contains(favoriteProduct)) {
      // Add to favorites
      await postFavoriteData(favoriteProduct);
    } else {
      // Remove from favorites
      await deleteFavourite(favoriteProduct.id);
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
      'category': favoriteProduct.category,
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
        await deleteFavourite(favoriteProduct.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error posting favorite: $e');
    }
  }

  Future<void> deleteFavourite(int id) async {
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
  void postCartData(Product bagProduct, BuildContext? context) async {
    final url = Uri.parse('http://192.168.0.111:3000/cartproducts');

    Map<String, dynamic> postCart = {
      'id': bagProduct.id,
      'thumbnail': bagProduct.thumbnail,
      'title': bagProduct.title,
      'brand': bagProduct.brand,
      'price': bagProduct.price,
      'cart_product_id': userUniqueId,
      'quantity': bagProduct.quantity,
    };

    debugPrint('postCart : $postCart');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(postCart),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Product successfully added
        // Add the product to bagProducts if it doesn't already exist
        if (!bagProducts.contains(bagProduct)) {
          bagProducts.add(bagProduct);
        }
        debugPrint('Product added to cart');
      } else if (response.statusCode == 200) {
        Navigator.of(context!).push(MaterialPageRoute(builder: (context) {
          return const ProductCartScreen();
        }));
        // Product already in the cart
        debugPrint('Product already in cart');
      } else {
        debugPrint('Failed to add product to cart: ${response.body}');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error posting cart data: $e');
    }
  }

  void getCartsData(String userId) async {
    final url = Uri.parse('http://192.168.0.111:3000/cartproducts/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final cartResponse = jsonDecode(response.body);
      debugPrint('cartResponse : $cartResponse');

      // Map the response to a List<Product>
      bagProducts = (cartResponse as List<dynamic>)
          .map((cartPro) => Product.fromMap(cartPro))
          .toList();

      debugPrint('bagProducts : $bagProducts');
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

// ORDERS API WORKING
  Future<void> fetchOrders(String userId, BuildContext context) async {
    final url =
        Uri.parse('http://192.168.0.111:3000/myorders/$userId'); // Backend URL

    try {
      final response = await http.get(url);
      debugPrint('response : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        orders = data; // Extract orders from the response
        debugPrint("orders : $orders");
        isLoadingOrderDetails = false;
        notifyListeners();
      } else {
        isLoadingOrderDetails = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load orders!')),
        );
        notifyListeners();
      }
    } catch (e) {
      isLoadingOrderDetails = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching orders: $e')),
      );
    }
  }

  void fetchOrderItems(String orderIdItems) async {
    final url =
        Uri.parse('http://192.168.0.111:3000/bookingcarts/$orderIdItems');

    debugPrint('Fetching items for orderItemsId: $orderIdItems');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        debugPrint('Response Data: $data');

        orderItems = data;
        isLoadingOrderList = false;
        notifyListeners();
      } else if (response.statusCode == 404) {
        errorMessage = 'No items found for the given order ID.';
        isLoadingOrderList = false;
        notifyListeners();
      } else {
        debugPrint('Failed to load data: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        errorMessage = 'Failed to load data. Please try again later.';
        isLoadingOrderList = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      errorMessage = 'An error occurred. Please check your connection.';
      isLoadingOrderList = false;
      notifyListeners();
    }
  }

  void updateQuantity(String uniqueId, Product bagProduct) async {
    // Define the URL
    final url =
        Uri.parse('http://192.168.0.111:3000/cartproducts/updateQuantity');

    // Prepare the request body
    final body = {
      'id': bagProduct.id,
      'cart_product_id': uniqueId, // Use cart_product_id from cartResponse
      'quantity': bagProduct.quantity,
    };

    try {
      // Send the PATCH request
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'}, // Use JSON headers
        body: jsonEncode(body), // Encode the body to JSON
      );

      // Handle the response
      if (response.statusCode == 200) {
        debugPrint('Quantity updated successfully: ${response.body}');
      } else {
        debugPrint(
            'Failed to update quantity: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      debugPrint('Error updating quantity: $error');
    }
  }
}
