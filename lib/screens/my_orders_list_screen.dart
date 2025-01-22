import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class MyOrdersListScreen extends StatefulWidget {
  final String orderItemsId;
  final String name;
  final String orderDate;
  final String address;
  final String orderStatus;

  const MyOrdersListScreen({
    super.key,
    required this.orderItemsId,
    required this.name,
    required this.orderDate,
    required this.address,
    required this.orderStatus,
  });

  @override
  MyOrdersListScreenState createState() => MyOrdersListScreenState();
}

class MyOrdersListScreenState extends State<MyOrdersListScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('initState Call()');

    // Delay the state update after the current build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('addPostFrameCallback Call()');
      context.read<ProductProvider>().fetchOrderItems(widget.orderItemsId);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BuildContext Call()');
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          'Orders',
          style: GoogleFonts.pacifico(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: providerWatch.isLoadingOrderList
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColor.appColor,
              ),
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
                                  // offset: const Offset(0, 1),
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
                                      RichText(
                                        text: TextSpan(
                                          text: 'Quantity : ',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '${product['quantity']}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: 5),
                                                  widget.orderStatus ==
                                                          "Delivered"
                                                      ? TextButton.icon(
                                                          label: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.edit,
                                                                size: 16,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                'Write a review',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            minimumSize:
                                                                Size(0, 0),
                                                          ),
                                                          onPressed: () {
                                                            providerRead
                                                                .showMDLBottomSheet(
                                                              context,
                                                              product,
                                                            );
                                                          },
                                                        )
                                                      : Text(''),
                                                ],
                                              ),
                                            ],
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
      bottomSheet: widget.orderStatus == 'Delivered'
          ? GestureDetector(
              onTap: () {
                final providerRead = context.read<ProductProvider>();
                providerRead.generatePDF(
                  providerRead.orderItems,
                  widget.name,
                  widget.address,
                  widget.orderDate,
                ); // Pass the orderItems to the PDF generator
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  color: AppColor.appColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Center(
                  child: Text(
                    'Download Invoice',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
