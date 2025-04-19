import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';

import '../product_provider/product_provider.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  @override
  void initState() {
    context.read<ProductProvider>().getUserReviews(userUniqueId);
    super.initState();
  }

  String formattedDate(String apiDate) {
    DateTime parsedDate = DateTime.parse(apiDate);
    return DateFormat('d MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final productRatingTitle = context.read<ProductProvider>().products;
    final providerRead = context.read<ProductProvider>();
    final providerWatch = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'My Reviews',
          style: GoogleFonts.pacifico(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: providerWatch.userReviews.isEmpty
          ? const Center(
              child: Text(
                'No reviews!',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : providerWatch.isUserReviewsLoad
              ? Center(
                  child: CircularProgressIndicator(color: AppColor.appColor),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: providerRead.userReviews.length,
                  itemBuilder: (context, index) {
                    final review = providerRead.userReviews[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Star Rating
                          RatingBar.builder(
                            initialRating: review['rating']?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {}, // No action needed
                            ignoreGestures: true,
                          ),
                          const SizedBox(height: 8),

                          // Product Title
                          Text(
                            productRatingTitle[index].title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Review Text
                          Text(
                            review['comment'] ?? 'No review provided.',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 8),

                          // Optional Images
                          if (review['reviewer_images'] != null &&
                              review['reviewer_images'] is List)
                            SizedBox(
                              height: 80,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: review['reviewer_images'].length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        review['reviewer_images'][index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 8),

                          // Reviewer Name and Date
                          Text(
                            "${review['reviewer_name'] ?? 'Anonymous'}, ${formattedDate(review['date'] ?? DateTime.now().toString())}",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('my_orders_screen');
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
              'Go to orders and review products',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
