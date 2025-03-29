import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';

class ProductsCard extends StatelessWidget {
  final VoidCallback onTap;
  final String thumbnail;
  final String rating;
  final String brand;
  final String title;
  final double price;
  final double discountPercentage;
  final bool favorite;
  final VoidCallback onPressed;
  final double vertical;
  final double horizontal;
  final double left;

  const ProductsCard({
    super.key,
    required this.onTap,
    required this.thumbnail,
    required this.rating,
    required this.brand,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.favorite,
    required this.onPressed,
    required this.vertical,
    required this.horizontal,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 210,
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffF3F3F3),
                ),
                child: SizedBox(
                  height: 200,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Center(
                      child: Image(
                        image: NetworkImage(
                          thumbnail,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('$rating'),
                    ),
                    Text(
                      brand,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '$price',
                      style: const TextStyle(
                        color: AppColor.appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: vertical,
          ),
          width: 50,
          height: 32,
          decoration: BoxDecoration(
            color: AppColor.appColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              '${discountPercentage.toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          left: left,
          top: 175,
          child: Container(
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
                icon: favorite
                    ? const Icon(Icons.favorite_border)
                    : const Icon(Icons.favorite),
                onPressed: onPressed,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
