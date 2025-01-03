import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class MyOrdersListScreen extends StatefulWidget {
  final String orderItemsId;
  final String name;
  final String orderDate;
  final String address;
  final String orderStatus;

  const MyOrdersListScreen({
    Key? key,
    required this.orderItemsId,
    required this.name,
    required this.orderDate,
    required this.address,
    required this.orderStatus,
  }) : super(key: key);

  @override
  _MyOrdersListScreenState createState() => _MyOrdersListScreenState();
}

class _MyOrdersListScreenState extends State<MyOrdersListScreen> {
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
                                                            showMDLBottomSheet(
                                                              context,
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
                generatePDF(
                  providerRead.orderItems,
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

  void generatePDF(List<dynamic> orderItems) async {
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
              pw.Text(widget.name),
              pw.Text(widget.address),
              pw.Text('Order ID: XYZ12345'),
              pw.Text('Order Date: ${widget.orderDate}'),

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
                  }).toList(),
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

  void showMDLBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColor.appBackgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Ensures the sheet can expand based on content
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
                top: 16.0,
              ), // Prevent content from being hidden
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    thickness: 4,
                    indent: 150,
                    endIndent: 150,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "What is your rate?",
                      style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star_border,
                        size: 40,
                        color: Colors.grey,
                      );
                    }),
                  ),
                  SizedBox(height: 18),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Please share your opinion\n about the product",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff222222),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the TextField
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none, // Removes default border
                        contentPadding:
                            EdgeInsets.all(16), // Padding inside the TextField
                        hintText: "Your review",
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color to white
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread radius of the shadow
                          blurRadius: 2, // Blur radius of the shadow
                          offset: Offset(0, 2), // Offset for the shadow (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.appColor,
                          radius: 30,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Add your photos",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
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
                      color: Colors.red, // Adjusted color
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Center(
                      child: Text(
                        'SEND REVIEW',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
