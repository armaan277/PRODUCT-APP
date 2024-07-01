import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';


import '../widgets/build_product_categories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Beauty',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: BuildProductCategories(
                    selectColor: AppColor.appBackgroundColor, selectCategory: 'beauty'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Fragrances',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: BuildProductCategories(
                    selectColor: AppColor.appBackgroundColor,
                    selectCategory: 'fragrances'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Furniture',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: BuildProductCategories(
                    selectColor: AppColor.appBackgroundColor,
                    selectCategory: 'furniture'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Groceries',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: BuildProductCategories(
                    selectColor: AppColor.appBackgroundColor,
                    selectCategory: 'groceries'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
