import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import '../screens/product_cart_screen.dart';

class ContainerButton extends StatefulWidget {
  final Product product;
  const ContainerButton({
    super.key,
    required this.product,
  });

  @override
  State<ContainerButton> createState() => ContainerButtonState();
}

class ContainerButtonState extends State<ContainerButton> {
  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColor.appColor,
          ),
          onPressed: () {
            if (!providerWatch.bagProducts.contains(widget.product)) {
              providerWatch.bagProducts.add(widget.product);
              providerRead.bagProductscountsInc();
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const ProductCartScreen();
              }));
            }
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined),
              const SizedBox(width: 10),
              Text(
                !providerWatch.bagProducts.contains(widget.product)
                    ? 'Add to Cart'
                    : 'Go to Bag',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
