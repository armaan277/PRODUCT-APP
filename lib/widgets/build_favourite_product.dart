import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../product_provider/product_provider.dart';

class BuildFavouriteProduct extends StatefulWidget {
  const BuildFavouriteProduct({super.key});

  @override
  State<BuildFavouriteProduct> createState() => _BuildFavouriteProductState();
}

class _BuildFavouriteProductState extends State<BuildFavouriteProduct> {
  @override
  void initState() {
    context.read<ProductProvider>().getSFProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();

    final favorites = providerRead.selectFavoriteCategories.isEmpty
        ? providerRead.favoriteProducts
        : providerWatch.favoriteProducts
            .where(
              (favorite) =>
                  favorite.category == providerWatch.selectFavoriteCategories,
            )
            .toList();
    return providerRead.favoriteProducts.isEmpty || favorites.isEmpty
        ? Center(
            child: Text(
              'No Favorite ❤️ Item Available !!!',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.network(
                          product.thumbnail,
                          width: 125,
                          height: 125,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                text: 'Brand: ',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: product.brand,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                product.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50),
                            Text(
                              '\$ ${product.price}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColor.appColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                product.rating > 4.50
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
                              ),
                            ),
                            Text(
                              product.warrantyInformation,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          providerRead.removeProductFromFavorite(product);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
