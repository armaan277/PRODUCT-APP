import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';

class ShowbottomsheetContainer extends StatelessWidget {
  final String size;
  final VoidCallback onTap;
  final String selectSize;
  const ShowbottomsheetContainer({
    super.key,
    required this.size,
    required this.selectSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          border: Border.all(
            width: 1.5,
            color: selectSize == 'selectsize'
                ? AppColor.appColor
                : Colors.grey.shade400,
          ),
        ),
        child: Center(
          child: Text(size),
        ),
      ),
    );
  }
}
