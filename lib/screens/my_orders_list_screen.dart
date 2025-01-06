import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
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
  int _rating = 0;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera, // Opens the camera
        preferredCameraDevice:
            CameraDevice.rear, // Optional: Rear or Front camera
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile; // Save the picked file
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

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
                                                  // widget.orderStatus ==
                                                  //         "Delivered"
                                                  //     ?
                                                  TextButton.icon(
                                                    label: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          size: 16,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Write a review',
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      minimumSize: Size(0, 0),
                                                    ),
                                                    onPressed: () {
                                                      showMDLBottomSheet(
                                                        context,
                                                        product,
                                                      );
                                                    },
                                                  )
                                                  // : Text(''),
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

  void showMDLBottomSheet(BuildContext context, Map product) {
    showModalBottomSheet(
      backgroundColor: AppColor.appBackgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Ensures the sheet can expand based on content
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 6,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Product Information Section
              Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              width: 90,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Colors.grey), // Add a border if needed
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // Match the container's radius
                                child: Image.network(
                                  product['thumbnail'],
                                  fit: BoxFit
                                      .cover, // Ensures the image covers the entire box
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _rating = index +
                                                  1; // Update rating when clicked
                                              print('_rating : $_rating');
                                            });
                                          },
                                          child: Icon(
                                            index < _rating
                                                ? Icons.star
                                                : Icons
                                                    .star_border, // Filled if clicked
                                            color: Colors.amber,
                                            size: 30,
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
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
              const SizedBox(height: 16),
              // Review Input Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: context.read<ProductProvider>().ratingController,
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

              const SizedBox(height: 16),
              Text(
                "Add your photos",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color to white
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ), // Optional: rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(1, 1.5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColor.appColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: IconButton(
                        onPressed: _openCamera,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: Image.file(
                          File(_imageFile!.path), // Display the captured image
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://via.placeholder.com/60', // Replace with your image URL
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Submit Review Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    postRating(product['id'], userUniqueId);
                    context.read<ProductProvider>().ratingController.clear();
                    _rating = 0;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.appColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Submit Review",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void postRating(int productId, String userId) async {
    final url = Uri.parse('http://192.168.0.111:3000/reviews/$productId');

    final postRatingData = {
      'product_id': productId,
      'rating': _rating, // Replace with dynamic rating if needed
      'comment': context.read<ProductProvider>().ratingController.text,
      'id': userId, // Add user ID
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
}
