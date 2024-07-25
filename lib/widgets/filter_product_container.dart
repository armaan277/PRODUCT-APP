import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';

class FilterProductContainer extends StatelessWidget {
  final VoidCallback onTapHTL;
  final VoidCallback onTapLTH;
  final VoidCallback onTapBR;
  final String price;
  const FilterProductContainer({
    super.key,
    required this.onTapHTL,
    required this.onTapLTH,
    required this.onTapBR,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColor.appBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              width: double.infinity,
              height: 260,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    height: 7,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.price_change,
                      color: Colors.green,
                    ),
                    title: const Text('Price: High To Low'),
                    onTap: onTapHTL,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.price_change_outlined,
                      color: Colors.green,
                    ),
                    title: const Text(
                      'Price: Low To High',
                    ),
                    onTap: onTapLTH,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    title: const Text('Rating: Best Rating'),
                    onTap: onTapBR,
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.grey.shade700,
                  size: 28,
                ),
               const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  color: Colors.grey.shade700,
                  size: 26,
                  Icons.swap_vert,
                ),
                Text(
                  'Price: $price',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.view_list,
              color: Colors.grey.shade700,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
