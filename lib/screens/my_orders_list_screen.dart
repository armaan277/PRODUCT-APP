import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:shopping_app/app.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class MyOrdersListScreen extends StatefulWidget {
  final String orderItemsId;

  const MyOrdersListScreen({Key? key, required this.orderItemsId})
      : super(key: key);

  @override
  _MyOrdersListScreenState createState() => _MyOrdersListScreenState();
}

class _MyOrdersListScreenState extends State<MyOrdersListScreen> {
  // List<dynamic> orderItems = [];
  // bool isLoading = true;
  // String errorMessage = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().fetchOrderItems(widget.orderItemsId);
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text('Orders',
            style: GoogleFonts.pacifico(
              color: Colors.white,
            )),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: providerWatch.isLoadingOrderList
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : providerRead.errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    providerRead.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : providerRead.orderItems.isEmpty
                  ? const Center(
                      child: Text('No items found'),
                    )
                  : ListView.builder(
                      itemCount: providerRead.orderItems.length,
                      itemBuilder: (context, index) {
                        final product = providerRead.orderItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Image.network(
                                      product['thumbnail'],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          product['title'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Brand: ',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: product['brand'],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Quantity : ',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '1',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10.0,
                                            ),
                                            child: Text(
                                              '\$ ${product['price']}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
