import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/products_card.dart';
import '../product_provider/product_provider.dart';
import '../screens/product_info_screen.dart';

class BuildGridviewProducts extends StatelessWidget {
  const BuildGridviewProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();

    final shopCategories = providerWatch.selectShopCategories == ''
        ? providerWatch.products.where((ele) {
            return ele.title.toLowerCase().contains(
                  providerRead.searchController.text.toLowerCase(),
                );
          }).toList()
        : providerWatch.products
            .where(
              (ele) =>
                  ele.category == providerWatch.selectShopCategories &&
                  ele.title.toLowerCase().contains(
                        providerRead.searchController.text.toLowerCase(),
                      ),
            )
            .toList();

    return shopCategories.isEmpty
        ? Center(
            child: Image.asset(
              'assets/products_not_found.png',
              width: 300,
            ),
          )
        : GridView.builder(
            itemCount: shopCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              final product = shopCategories[index];
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
                  context.read<ProductProvider>().toggleFavoriteStatus(product,context);
                },
                vertical: 12.0,
                horizontal: 12.0,
                left: 150,
              );
            },
          );
  }
}
