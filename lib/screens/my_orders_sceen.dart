import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/my_orders_list_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    debugPrint('initState Call()');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('addPostFrameCallback Call()');
      context.read<ProductProvider>().fetchOrders(userUniqueId, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BuildContext build()');
    final providerRead = context.read<ProductProvider>();
    final providerWatch = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: AppColor.appColor,
        title: Text(
          'My Orders',
          style: GoogleFonts.pacifico(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: providerWatch.isLoadingOrderDetails
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColor.appColor,
              ),
            )
          : providerRead.orders.isEmpty
              ? const Center(
                  child: Text('No orders found'),
                )
              : ListView.builder(
                  itemCount: providerRead.orders.length,
                  itemBuilder: (context, index) {
                    final order = providerRead.orders[index];

                    debugPrint('order_items_id : ${order['order_items_id']}');

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Number and Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Id: ${order['orders_id'] ?? ''}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      order['order_booking_date'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    order['order_status'] == 'Confirmed' ||
                                            order['order_status'] ==
                                                'Out for Delivery'
                                        ? SizedBox(
                                            height: 22,
                                            child: PopupMenuButton<String>(
                                              color: Colors.white,
                                              icon: Icon(Icons.more_vert),
                                              padding: EdgeInsets.all(0.0),
                                              onSelected: (String value) {
                                                order['order_status'] = value;
                                                providerRead
                                                    .cancelStatusInDatabase(
                                                  order['order_items_id'],
                                                  order['order_status'],
                                                );
                                                debugPrint(
                                                    'order["order_status"]: ${order['order_status']}');
                                              },
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                PopupMenuItem(
                                                  height: 10,
                                                  value: 'Canceled',
                                                  child: Text(
                                                    'Cancel Order',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Tracking Number
                            Text(
                              "Name: ${order['name'] ?? ''}",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Quantity and Amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Amount: ${order['price']?.toStringAsFixed(2) ?? '0.00'}\$",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Buttons Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MyOrdersListScreen(
                                            orderItemsId:
                                                order['order_items_id'],
                                            name: order['name'],
                                            orderDate:
                                                order['order_booking_date'],
                                            address: order['address'],
                                            orderStatus: order['order_status'],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.appColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text("Details"),
                                ),
                                Text(
                                  '${order['order_status']}',
                                  style: TextStyle(
                                    color: order['order_status'] == 'Delivered'
                                        ? Colors.green
                                        : order['order_status'] == 'Canceled'
                                            ? Colors.red
                                            : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
