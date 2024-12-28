import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyOrdersListScreen extends StatefulWidget {
  final String orderItemsId;

  const MyOrdersListScreen({Key? key, required this.orderItemsId})
      : super(key: key);

  @override
  _MyOrdersListScreenState createState() => _MyOrdersListScreenState();
}

class _MyOrdersListScreenState extends State<MyOrdersListScreen> {
  List<dynamic> orderItems = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrderItems(widget.orderItemsId);
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

        setState(() {
          orderItems = data;
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'No items found for the given order ID.';
          isLoading = false;
        });
      } else {
        debugPrint('Failed to load data: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        setState(() {
          errorMessage = 'Failed to load data. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        errorMessage = 'An error occurred. Please check your connection.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Carts'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : orderItems.isEmpty
                  ? const Center(child: Text('No items found'))
                  : ListView.builder(
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];

                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: item['thumbnail'] != null &&
                                    item['thumbnail'] != ""
                                ? Image.network(
                                    item['thumbnail'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(item['title'] ?? 'No Title'),
                            subtitle: Text(item['brand'] ?? 'No Description'),
                            trailing: Text('\$${item['price'] ?? 0}'),
                          ),
                        );
                      },
                    ),
    );
  }
}
