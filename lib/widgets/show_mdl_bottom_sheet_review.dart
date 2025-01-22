import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../product_provider/product_provider.dart';

class ShowMdlBottomSheetReview extends StatefulWidget {
  final Map product;
  const ShowMdlBottomSheetReview({
    super.key,
    required this.product,
  });

  @override
  State<ShowMdlBottomSheetReview> createState() =>
      _ShowMdlBottomSheetReviewState();
}

class _ShowMdlBottomSheetReviewState extends State<ShowMdlBottomSheetReview> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera, // Opens the camera
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(pickedFile); // Add the new image to the list
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (var imageFile in _imageFiles) {
      final file = File(imageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        await Supabase.instance.client.storage
            .from('images') // Replace 'reviews' with your storage bucket
            .upload(fileName, file);

        final imageUrl = await Supabase.instance.client.storage
            .from('images')
            .getPublicUrl(fileName);

        imageUrls.add(imageUrl);
      } catch (e) {
        debugPrint("Image upload error: $e");
      }
    }
    return imageUrls;
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index); // Remove the image at the specified index
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
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
                                color: Colors.grey), // Add a border if needed
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Match the container's radius
                            child: Image.network(
                              widget.product['thumbnail'],
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
                                  widget.product['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            providerRead.rating = index +
                                                1; // Update rating when clicked
                                            debugPrint(
                                                '_rating : ${providerRead.rating}');
                                          });
                                        },
                                        child: Icon(
                                          index < providerRead.rating
                                              ? Icons.star
                                              : Icons
                                                  .star_border, // Filled if clicked
                                          color: Colors.amber,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
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
              controller: providerRead.ratingController,
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
                Expanded(
                  child: SizedBox(
                    height: 90,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      scrollDirection:
                          Axis.horizontal, // Makes the list horizontal
                      itemCount: _imageFiles.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              child: Image.file(
                                File(
                                  _imageFiles[index].path,
                                ), // Display the captured image
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Remove icon
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
              onPressed: () async {
                List<String> imageUrls = await _uploadImages();
                debugPrint('imageUrls : $imageUrls');
                providerRead.postRating(
                  context,
                  widget.product['id'],
                  userUniqueId,
                  imageUrls,
                );
                providerRead.ratingController.clear();
                providerRead.rating = 0;
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
  }
}
