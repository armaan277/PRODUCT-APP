import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/widgets/favorite_container.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  FavoriteContainer(
                    title: 'All',
                    select: providerWatch.select == '' ? 'select' : '',
                    onTap: () {
                      providerRead.favoriteChip('');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Beauty',
                    select: providerWatch.select == 'beauty' ? 'select' : '',
                    onTap: () {
                      providerRead.favoriteChip('beauty');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Fragrances',
                    select:
                        providerWatch.select == 'fragrances' ? 'select' : '',
                    onTap: () {
                      providerRead.favoriteChip('fragrances');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Furniture',
                    select: providerWatch.select == 'furniture' ? 'select' : '',
                    onTap: () {
                      providerRead.favoriteChip('furniture');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Groceries',
                    select: providerWatch.select == 'groceries' ? 'select' : '',
                    onTap: () {
                      providerRead.favoriteChip('groceries');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: buildFavoriteProductListView(context),
          ),
        ],
      ),
    );
  }

  Widget buildFavoriteProductListView(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();

    final favorites = providerWatch.favoriteProducts
        .where((favorite) => favorite.category == providerWatch.select)
        .toList();
    return providerWatch.select.isEmpty
        ? ListView.builder(
            itemCount: providerWatch.favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = providerWatch.favoriteProducts[index];
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
                          product.images.first,
                          width: 125.0,
                          height: 125.0,
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
                            SizedBox(width: 50),
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
                          providerRead.removeProductFromFavorite(index);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : favorites.isNotEmpty
            ? ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final product = favorites[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
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
                              product.images.first,
                              height: 125.0,
                              width: 125.0,
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
                                SizedBox(width: 50),
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
                              providerRead.removeProductFromFavorite(index);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'No Favorite ❤️ Item Available !!!',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
  }
}
