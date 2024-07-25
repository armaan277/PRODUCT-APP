import 'package:flutter/material.dart';
import '../constant/constant.dart';
import 'build_product_categories.dart';

class BuildProducts extends StatelessWidget {
  final String title;
  final String productCategory;
  const BuildProducts({
    super.key,
    required this.title,
    required this.productCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 310,
          child: BuildProductCategories(
            selectColor: AppColor.appBackgroundColor,
            selectCategory: productCategory,
          ),
        ),
      ],
    );
  }
}
