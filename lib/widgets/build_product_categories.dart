import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/product_info_screen.dart';
import 'package:shopping_app/widgets/products_card.dart';

class BuildProductCategories extends StatelessWidget {
  final String selectCategory;
  final Color selectColor;
  final Product? product;
  const BuildProductCategories({
    super.key,
    required this.selectCategory,
    required this.selectColor,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();

    final categories = providerWatch.products
        .where(
          (categories) =>
              categories.category == selectCategory &&
              categories.id != product?.id,
        )
        .toList();

    return Scaffold(
      backgroundColor: selectColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 5.0),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final product = categories[index];
                final favorite =
                    !providerWatch.favoriteProducts.contains(product);
                return ProductsCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductInfoScreen(
                            product: product,
                          );
                        },
                      ),
                    );
                  },
                  thumbnail: product.thumbnail,
                  rating: product.rating > 4.50
                      ? '⭐⭐⭐⭐⭐'
                      : product.rating > 4
                          ? '⭐⭐⭐⭐'
                          : product.rating > 3
                              ? '⭐⭐⭐'
                              : product.rating > 2
                                  ? '⭐⭐'
                                  : product.rating > 1
                                      ? '⭐'
                                      : '',
                  brand: product.brand,
                  title: product.title,
                  price: product.price,
                  discountPercentage: product.discountPercentage.toDouble(),
                  favorite: favorite,
                  onPressed: () {
                    context
                        .read<ProductProvider>()
                        .toggleFavoriteStatus(product);
                  },
                  vertical: 15,
                  horizontal: 18,
                  left: 176,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
