import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/product_info_screen.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return providerWatch.isProductLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColor.appColor,
            ),
          )
        : GridView.builder(
            itemCount: providerWatch.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              final product = providerWatch.products[index];
              final favorite =
                  !providerWatch.favoriteProducts.contains(product);
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xffF3F3F3),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductInfo(
                                        product: product,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Image(
                                image: NetworkImage(
                                  product.thumbnail,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
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
                                product.brand,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                product.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '\$ ${product.price}',
                                style: const TextStyle(
                                  color: AppColor.appColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 18.0,
                    ),
                    width: 50,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColor.appColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        '${product.discountPercentage.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 175,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: IconButton(
                          icon: favorite
                              ? const Icon(Icons.favorite_border)
                              : const Icon(Icons.favorite),
                          onPressed: () {
                            providerRead.favoriteProduct(product);
                          },
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
