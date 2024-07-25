import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';

class FavoriteContainer extends StatelessWidget {
  final String title;
  final String select;
  final VoidCallback onTap;
  const FavoriteContainer({
    super.key,
    required this.title,
    required this.select,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: select == 'select' ? AppColor.appColor : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: AppColor.appColor),
          ),
          height: 40,
          child: Text(
            title,
            style: TextStyle(
              color: select == 'select' ? Colors.white : AppColor.appColor,
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ),
      ),
    );
  }
}
