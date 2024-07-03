import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/widgets/container_button.dart';
import 'showbottomsheet_container.dart';

class ShowModalBottomSheet extends StatefulWidget {
  final Product product;
  const ShowModalBottomSheet({
    super.key,
    required this.product,
  });

  @override
  State<ShowModalBottomSheet> createState() => ShowModalBottomSheetState();
}

class ShowModalBottomSheetState extends State<ShowModalBottomSheet> {
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
              height: 300,
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
                    'Select Size',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ShowbottomsheetContainer(
                        size: 'S',
                        selectSize:
                            context.watch<ProductProvider>().selectSize == 'S'
                                ? 'selectsize'
                                : '',
                        onTap: () {
                          context.read<ProductProvider>().selectSizes('S');
                        },
                      ),
                      ShowbottomsheetContainer(
                        size: 'M',
                        selectSize:
                            context.watch<ProductProvider>().selectSize == 'M'
                                ? 'selectsize'
                                : '',
                        onTap: () {
                          context.read<ProductProvider>().selectSizes('M');
                        },
                      ),
                      ShowbottomsheetContainer(
                        size: 'L',
                        selectSize:
                            context.watch<ProductProvider>().selectSize == 'L'
                                ? 'selectsize'
                                : '',
                        onTap: () {
                          context.read<ProductProvider>().selectSizes('L');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ShowbottomsheetContainer(
                        size: 'X',
                        selectSize:
                            context.watch<ProductProvider>().selectSize == 'X'
                                ? 'selectsize'
                                : '',
                        onTap: () {
                          context.read<ProductProvider>().selectSizes('X');
                        },
                      ),
                      ShowbottomsheetContainer(
                        size: 'XL',
                        selectSize:
                            context.watch<ProductProvider>().selectSize == 'XL'
                                ? 'selectsize'
                                : '',
                        onTap: () {
                          context.read<ProductProvider>().selectSizes('XL');
                        },
                      ),
                      ShowbottomsheetContainer(
                        size: 'XXL',
                        selectSize:
                            context.watch<ProductProvider>().selectSize == 'XXL'
                                ? 'selectsize'
                                : '',
                        onTap: () {
                          context.read<ProductProvider>().selectSizes('XXL');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ContainerButton(product: widget.product),
                ],
              ),
            );
          },
        );
      
      },
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColor.appColor),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Size',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }
}
