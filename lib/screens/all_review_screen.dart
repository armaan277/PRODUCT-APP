import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/model/product.dart';

class AllReviewScreen extends StatefulWidget {
  final Product product;
  final List reviews;

  const AllReviewScreen({
    super.key,
    required this.reviews,
    required this.product,
  });

  @override
  State<AllReviewScreen> createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> {
  int? selectedRatingFilter; // Variable to store the selected filter

  List getFilteredReviews() {
    if (selectedRatingFilter == null) {
      return widget.reviews; // Show all reviews if no filter is applied
    }
    return widget.reviews
        .where((review) => review['rating'] == selectedRatingFilter)
        .toList();
  }

  String formattedDate(String apiDate) {
    DateTime parsedDate = DateTime.parse(apiDate);
    return DateFormat('d MMM yyyy').format(parsedDate);
  }

  Widget buildReview(BuildContext context, Map<String, dynamic> review) {
    return Column(
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
          widget.product.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Review Text
        Text(
          review['comment'] ?? 'No review provided.',
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
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
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
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
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredReviews = getFilteredReviews();
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
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
          'All Reviews',
          style: GoogleFonts.pacifico(
            letterSpacing: 1.1,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.appColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12), // Adjust the radius as needed
                  ),
                ),
                builder: (context) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            leading: const Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppColor.appColor,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[00],
                          thickness: 1,
                        ),
                        ListTile(
                          leading: const Text(
                            'All Stars',
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              selectedRatingFilter = null;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        for (int i = 1; i <= 5; i++)
                          ListTile(
                            leading: Text(
                              '$i Star${i > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: selectedRatingFilter == i
                                    ? AppColor.appColor
                                    : null,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedRatingFilter = i;
                              });
                              Navigator.of(context).pop();
                            },
                            trailing: Icon(
                              color: AppColor.appColor,
                              selectedRatingFilter == i ? Icons.check : null,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: filteredReviews.isEmpty
          ? Center(
              child: Text(
                'No Reviews',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: getFilteredReviews().length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 32,
              ),
              itemBuilder: (context, index) {
                final review = getFilteredReviews()[index];
                return buildReview(context, review);
              },
            ),
    );
  }
}
