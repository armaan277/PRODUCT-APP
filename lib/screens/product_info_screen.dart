import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/all_review_screen.dart';
import 'package:shopping_app/widgets/build_product_categories.dart';
import 'package:shopping_app/widgets/container_button.dart';
import '../model/product.dart';
import '../widgets/show_modal_bottom_sheet.dart';

class ProductInfoScreen extends StatefulWidget {
  final Product product;
  const ProductInfoScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  @override
  void initState() {
    super.initState(); // Call super first
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final providerRead = context.read<ProductProvider>();
    await providerRead.getReviewData(widget.product.id); // Fetch reviews
    setState(() {}); // Update the UI after fetching data
  }

  int currentIndex = 0;
  final carouselController = CarouselSliderController();

  String formattedDate(String apiDate) {
    DateTime parsedDate = DateTime.parse(apiDate); // Parse the date string
    return DateFormat('d MMM yyyy').format(parsedDate); // Format the date
  }

  double calculateReviews() {
    final providerRead = context.read<ProductProvider>();

    // Calculate the total sum of all ratings
    double total = providerRead.reviews
        .map((ele) => ele['rating']) // Extract ratings
        .fold(0, (prev, rating) => prev + rating); // Accumulate the sum
    print('Total ratings: $total');

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    final providerWatch = context.watch<ProductProvider>();
    final favorite = providerWatch.favoriteProducts.contains(widget.product);
    final lastReviewImages =
        providerRead.reviews.isNotEmpty ? providerRead.reviews.last : [];
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          'Product Detail',
          style: GoogleFonts.pacifico(
            letterSpacing: 1.1,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Opacity(
              opacity:
                  context.watch<ProductProvider>().isProductAddInCart ? 0.2 : 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CarouselSlider(
                      items: widget.product.images.map((image) {
                        return Image.network(image);
                      }).toList(),
                      options: CarouselOptions(
                        height: 300,
                        autoPlay:
                            widget.product.images.length > 1 ? true : false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                      carouselController: carouselController,
                    ),
                  ),
                  if (widget.product.images.length > 1)
                    DotsIndicator(
                      dotsCount: widget.product.images.length,
                      position: currentIndex,
                      decorator: DotsDecorator(
                        color: Colors.grey,
                        activeColor: AppColor.appColor,
                        size: const Size.square(9.0),
                        activeSize: const Size(12.0, 12.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onTap: (index) {
                        carouselController.animateToPage(index);
                      },
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$ ${widget.product.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.appColor,
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 22,
                                      child: IconButton(
                                          onPressed: () {
                                            providerRead.toggleFavoriteStatus(
                                                widget.product, context);
                                          },
                                          icon: Icon(
                                            favorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 30,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ),
                                  Text(
                                    widget.product.stock == 0
                                        ? 'Out of stock'
                                        : widget.product.stock < 5
                                            ? 'Low Stock'
                                            : 'In Stock',
                                    style: TextStyle(
                                      color: widget.product.stock < 5
                                          ? Colors.red
                                          : widget.product.stock == 0
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            textAlign: TextAlign.justify,
                            widget.product.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Brand: ${widget.product.brand}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Discount: ${widget.product.discountPercentage}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.appColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '⭐ ${(calculateReviews() / providerRead.reviews.length).toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.product.category == 'mens-shirts' ||
                                      widget.product.category ==
                                          'womens-dresses' ||
                                      widget.product.category == 'tops'
                                  ? ShowModalBottomSheet(
                                      product: widget.product,
                                    )
                                  : Text(''),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 55,
                            color: Colors.white,
                            child: ContainerButton(product: widget.product),
                          ),
                          const Text(
                            'Similar Products',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 310,
                    child: BuildProductCategories(
                      product: widget.product,
                      selectColor: Colors.white,
                      selectCategory: widget.product.category,
                    ),
                  ),
                  // When review is loading show CirProIndi
                  // providerRead.reviews.isEmpty
                  //     ? CircularProgressIndicator(
                  //         color: AppColor.appColor,
                  //       )
                  //     :
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: providerRead.reviews.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                const Text(
                                  'Ratings & Reviews',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Overall Rating Section 2 / total_reviews
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(width: 10),
                                            Text(
                                              "${(calculateReviews() / providerRead.reviews.length).toStringAsFixed(1)}/",
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "5",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Overall Rating",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${providerRead.reviews.length} Ratings",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    RatingBarIndicator(
                                      rating: calculateReviews() /
                                          providerRead
                                              .reviews.length, // Average rating
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5, // Max rating value
                                      itemSize: 22.0, // Star size
                                      direction:
                                          Axis.horizontal, // Horizontal layout
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Review Description
                                Text(
                                  providerRead.reviews.last['comment'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Images Row
                                if (lastReviewImages != null &&
                                    lastReviewImages["reviewer_images"] != null)
                                  Row(
                                    children: List.generate(
                                        (lastReviewImages["reviewer_images"]
                                                as List)
                                            .length, (index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          lastReviewImages[
                                                                  'reviewer_images']
                                                              [
                                                              index], // Replace with your image URL
                                                          height:
                                                              300, // Increased height for better display
                                                          width:
                                                              300, // Increased width for better display
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top:
                                                            4, // Adjust positioning
                                                        right:
                                                            4, // Adjust positioning
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6), // Background for better visibility
                                                            ),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors
                                                                  .white, // Close icon color
                                                              size:
                                                                  20, // Close icon size
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              lastReviewImages[
                                                      'reviewer_images'][
                                                  index], // Replace with your image URL
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                const SizedBox(width: 10),
                                const SizedBox(height: 10),
                                // Reviewer Info
                                Text(
                                  "${providerRead.reviews.last['reviewer_name'] ?? ''}, ${formattedDate(providerRead.reviews.last['date'] ?? '')}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // View All Reviews
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return AllReviewScreen(
                                        reviews: providerRead.reviews,
                                        product: widget.product,
                                      );
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "View All ${providerRead.reviews.length} Reviews",
                                        style: TextStyle(
                                          color: AppColor.appColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: AppColor.appColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          if (context.watch<ProductProvider>().isProductAddInCart)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: CircularProgressIndicator(
                  color: AppColor.appColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
