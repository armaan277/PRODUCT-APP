import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/config/endponts.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import 'package:shopping_app/widgets/bottom_navigation_bar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:shopping_app/widgets/show_mdl_bottom_sheet_review.dart';

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
  final phoneController = TextEditingController();

  bool isAddressStoreInDatabase = false;

  // Orders Details Variable
  List<dynamic> orders = [];
  bool isLoadingOrderDetails = true;

  // Orders List Variable
  List<dynamic> orderItems = [];
  bool isLoadingOrderList = true;
  String errorMessage = '';
  String? errorMessageLogIn;

  // Login TextContreller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Review TextContreller
  final ratingController = TextEditingController();

  int rating = 0;

  List reviews = [];

  final signupNameController = TextEditingController();
  final signupPhoneController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();

  List<dynamic> userDetails = [];

  List<dynamic> userReviews = [];
  bool isUserReviewsLoad = true;

  bool isLogin = false;

  bool isFavorite = false;

  bool isProductAddInCart = false;

  Future<void> getProducts() async {
    final response = await http.get(Uri.parse(Endponts.getAllProductsEndPoint));

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
    totalPriceCartItems();
    notifyListeners();
  }

  void productInfoDec(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
      totalPriceCartItems();
      notifyListeners();
    }
  }

  void removeProductFromBag(int index, Product product) {
    bagProducts.removeAt(index);
    totalPriceCartItems();
    debugPrint('removeProductFromBagTotalPrice : $totalPrice');
    notifyListeners();
  }

  void removeProductFromFavorite(Product product) {
    favoriteProducts.removeWhere((ele) => ele.id == product.id);
    notifyListeners();
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

// LOGIN WORK
  Future<void> postLoginData(BuildContext context) async {
    final url = Uri.parse(Endponts.loginEndPoint);

    final loginData = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    isLogin = true;
    notifyListeners();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    final signUpResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      userUniqueId = signUpResponse['user']['id'] ?? '';
      isLogin = false;
      debugPrint('userUniqueId : $userUniqueId');
      debugPrint('Successfully LogedIn');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userUniqueId', userUniqueId);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
      );
      errorMessageLogIn = '';
      notifyListeners();
    } else if (response.statusCode == 401) {
      errorMessageLogIn = 'Invalid email or password!';
      isLogin = false;
      debugPrint('errorMessage : $errorMessageLogIn');
      notifyListeners();
    } else {
      isLogin = false;
      debugPrint('Invalid email or password !!!');
      notifyListeners();
    }
  }

  // SignUp Work
  void postSignUpData() async {
    final url = Uri.parse(Endponts.signUpEndPoint);

    final signUpData = {
      'id': userUniqueId,
      'name': signupNameController.text,
      'phone': signupPhoneController.text,
      'email': signupEmailController.text,
      'password': signupPasswordController.text,
    };

    http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signUpData),
    );
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
    final url = Uri.parse('${Endponts.getUserFavouritesEndPoint}/$userId');
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
    final url = Uri.parse(Endponts.postUserFavouriteEndPoint);
    isFavorite = true;
    notifyListeners();

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
          isFavorite = false;
          favoriteProducts.add(favoriteProduct);
          notifyListeners();
        } else {
          isFavorite = false;

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
    final url = Uri.parse('${Endponts.deleteUserFavouriteEndPoint}/$id');
    isFavorite = true;
    notifyListeners();
    try {
      final response = await http.delete(url);

      debugPrint('deleteFavouriteResponse : ${response.body}');
      if (response.statusCode == 200) {
        favoriteProducts.removeWhere((product) => product.id == id);
        isFavorite = false;
        notifyListeners();
      } else {
        debugPrint('Failed to delete favorite: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting favorite: $e');
    }
  }

  // CART API WORK
  Future<void> postCartData(Product bagProduct, BuildContext? context) async {
    final url = Uri.parse(Endponts.postUserCartProductsEndPoint);

    isProductAddInCart = true;
    notifyListeners();

    Map<String, dynamic> postCart = {
      'id': bagProduct.id,
      'thumbnail': bagProduct.thumbnail,
      'title': bagProduct.title,
      'brand': bagProduct.brand,
      'price': bagProduct.price.toDouble(),
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
        isProductAddInCart = false;
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

  void totalPriceCartItems() {
    totalPrice = 0.0;
    for (var bagProduct in bagProducts) {
      totalPrice += bagProduct.price * bagProduct.quantity;
    }
    notifyListeners();
  }

  void getCartsData(String userId) async {
    final url = Uri.parse('${Endponts.getUserCartsProductsEndPoint}/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final cartResponse = jsonDecode(response.body);
      debugPrint('cartResponse : $cartResponse');

      // Map the response to a List<Product>
      bagProducts = (cartResponse as List<dynamic>)
          .map((cartPro) => Product.fromMap(cartPro))
          .toList();

      totalPriceCartItems();

      debugPrint('bagProducts bagProducts : $bagProducts');
      isProductLoading = false;
      notifyListeners();
    } else {
      debugPrint('Failed to load data');
    }
  }

  void deleteCartData(int id) async {
    final url = Uri.parse('${Endponts.deleteUserCartProductsEndPoint}/$id');

    try {
      final response = await http.delete(url);

      debugPrint('deleteCartResponse: ${response.body}');

      if (response.statusCode == 200) {
        bagProducts.removeWhere((product) => product.id == id);

        debugPrint('Updated Total Price: $totalPrice');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
    }
  }

  // ADDRESS API WORK
  Future<void> getAddressData() async {
    final url = Uri.parse('${Endponts.getUserAddressEndPoint}/$userUniqueId');
    debugPrint('getAddressData : $userUniqueId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint('response.statusCode == 200');
        final List<dynamic> responseBody = jsonDecode(response.body);
        debugPrint('responseBody : $responseBody');
        if (responseBody.isNotEmpty) {
          debugPrint('responseBody.isNotEmpty');
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
        nameController.clear();
        addressController.clear();
        cityController.clear();
        stateController.clear();
        zipcodeController.clear();
        countryController.clear();
        // Address not available
        debugPrint('response.statusCode == 404');
        isAddressStoreInDatabase = false;

        debugPrint('isAddressStoreInDatabase : $isAddressStoreInDatabase');
        notifyListeners();
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
    final url = Uri.parse(Endponts.postUserAddressEndPoint);

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
    final url = Uri.parse('${Endponts.postUserAddressEndPoint}/$userId');

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
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now); // 24-hour format
    final url = Uri.parse('${Endponts.postUserAddressIDEndPoint}/$userId');

    final data = {
      'address_id': userId,
      'order_booking_time': formattedTime,
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
    final url = Uri.parse('${Endponts.deleteUserOrderCartsProducts}/$userId');

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
        Uri.parse('${Endponts.getUserOrdersEndPoint}/$userId'); // Backend URL

    try {
      // Clear existing orders and set loading state
      isLoadingOrderDetails = true;
      orders.clear();
      notifyListeners();
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
        Uri.parse('${Endponts.getUserOrderItemsEndPoint}/$orderIdItems');

    debugPrint('Fetching items for orderItemsId: $orderIdItems');
    // Clear existing data and set loading state BEFORE making the network call
    isLoadingOrderList = true;
    orderItems.clear();
    errorMessage = ''; // Clear any previous error messages
    notifyListeners();
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
    final url = Uri.parse(Endponts.patchUserCartQtyUpdateEndPoint);

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

  bool isReviewPost = false;

  void setReviewPosting(bool value) {
    isReviewPost = value;
    notifyListeners(); // UI Update Hoga
  }

  // Rating Work
  Future<void> postRating(
    BuildContext context,
    int productId,
    String userId,
    List<String> reviewImages,
  ) async {
    final url = Uri.parse('${Endponts.postUserReviewsEndPoint}/$productId');

    final postRatingData = {
      'product_id': productId,
      'rating': rating, // Replace with dynamic rating if needed
      'comment': ratingController.text,
      'id': userId, // Add user ID
      'reviewer_images': reviewImages,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(postRatingData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your Review Successfully Submitted'),
          ),
        );
        // Successfully posted the rating
        debugPrint('Rating submitted successfully: ${response.body}');
      } else {
        // Handle errors
        debugPrint(
            'Failed to submit rating. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (error) {
      // Handle network or JSON errors
      debugPrint('Error submitting rating: $error');
    }
  }

  Future<void> getReviewData(int productId) async {
    try {
      // Construct the API URL
      final url = Uri.parse('${Endponts.getAllReviewsEndPoint}/$productId');

      // Send GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the response body
        final reviewsResponse = jsonDecode(response.body);
        reviews = reviewsResponse;
        debugPrint('Reviews: $reviews'); // Debugging log
      } else {
        debugPrint(
            'Failed to load reviews. Status code: ${response.statusCode}');
        if (response.statusCode == 404) {
          reviews = [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching reviews: $e'); // Handle errors
    }
  }

// This Function used in OrderItems Screen for Post Reviews
  void showMDLBottomSheet(BuildContext context, Map product) {
    showModalBottomSheet(
      backgroundColor: AppColor.appBackgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Ensures the sheet can expand based on content
      builder: (context) {
        return ShowMdlBottomSheetReview(product: product);
      },
    );
  }

  // Generate PDF
  void generatePDF(
    List<dynamic> orderItems,
    String name,
    String address,
    String orderDate,
  ) async {
    final pdf = pw.Document();

    // Calculate subtotal
    double subtotal = orderItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double tax = subtotal * 0.10; // Example: 10% tax
    double total = subtotal + tax;

    // Create PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Invoice',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('E-commerce App'),
                  pw.Text('123, AM Company'),
                  pw.Text('Mumbai, India'),
                  pw.Text('Email: am@gmail.com'),
                ],
              ),

              pw.SizedBox(height: 20),

              // Bill To Section
              pw.Text(
                'Bill To:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(name),
              pw.Text(address),
              pw.Text('Order ID: XYZ12345'),
              pw.Text('Order Date: ${orderDate}'),

              pw.SizedBox(height: 20),

              // Table for Order Items
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Quantity',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Unit Price',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Table Rows for Items
                  ...orderItems.map((item) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(item['title']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${item['quantity']}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('\$${item['price']}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '\$${item['price'] * item['quantity']}',
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),

              // Subtotal, Tax, Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Tax (10%): \$${tax.toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Thank you for shopping with us!'),
            ],
          );
        },
      ),
    );

    // Save PDF
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'invoice.pdf'));
    await file.writeAsBytes(await pdf.save());

    // Open the PDF
    await OpenFile.open(file.path);
  }

  Future<bool> cancelStatusInDatabase(
      String orderId, String orderStatus) async {
    final url = Uri.parse(
        '${Endponts.cancelStatusInDatabaseEndPoint}/$orderId'); // Fixed endpoint

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'order_status': orderStatus}),
      );

      if (response.statusCode == 200) {
        debugPrint('Status updated successfully: $orderStatus');
        notifyListeners();
        return true;
      } else {
        debugPrint('Failed to update status: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error updating status: $e');
      notifyListeners();
      return false;
    }
  }

  // This code is used in app_drawer.dart file
  void getUserDetails(String id) async {
    try {
      final response =
          await http.get(Uri.parse('${Endponts.getUserDetailsEndPoint}/$id'));

      if (response.statusCode == 200) {
        // Ensure response is successful
        final listResponse = jsonDecode(response.body);
        debugPrint('mapResponse : $listResponse');

        userDetails.clear(); // Clear old data before adding new

        userDetails = listResponse;
        notifyListeners();
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e'); // Handle any unexpected errors
    }
  }

  String newName(String name) {
    String newName = name[0];

    for (int i = 0; i < name.length - 1; i++) {
      if (name[i] == ' ') {
        newName = newName + name[i + 1];
      }
    }
    return newName;
  }

  void getUserReviews(String id) async {
    try {
      final response =
          await http.get(Uri.parse('${Endponts.getUserReviewsEndPoint}/$id'));

      if (response.statusCode == 200) {
        // Ensure response is successful
        final listResponse = jsonDecode(response.body);
        debugPrint('mapResponse : $listResponse');

        userReviews.clear(); // Clear old data before adding new

        for (var item in listResponse) {
          userReviews.add(item);
        }
        isUserReviewsLoad = false;
        notifyListeners();
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e'); // Handle any unexpected errors
    }
  }
}
