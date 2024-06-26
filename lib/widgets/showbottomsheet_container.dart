import 'package:flutter/material.dart';

class ShowbottomsheetContainer extends StatelessWidget {
  final String size;
  const ShowbottomsheetContainer({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: Center(
        child: Text(size),
      ),
    );
  }
}
