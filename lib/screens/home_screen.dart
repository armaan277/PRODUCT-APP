import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/product_info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Beauty',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: buildCategories(context, 'beauty'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Fragrances',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: buildCategories(context, 'fragrances'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Furniture',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: buildCategories(context, 'furniture'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Groceries',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 310,
                child: buildCategories(context, 'groceries'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories(BuildContext context, String selectCategory) {
    final providerWatch = context.watch<ProductProvider>();

    final categories = providerWatch.products
        .where((categories) => categories.category == selectCategory)
        .toList();
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(width: 10),
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final product = categories[index];
        final favorite = !providerWatch.favoriteProducts.contains(product);

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                width: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
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
                      child: Container(
                        height: 205,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffF1F1F1),
                        ),
                        child: Center(
                          child: Image.network(product.images.first),
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
                            product.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
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
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
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
              left: 180,
              top: 178,
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
                  child: IconButton(
                    icon: favorite
                        ? const Icon(
                            Icons.favorite_outline,
                          )
                        : const Icon(Icons.favorite),
                    onPressed: () {
                      context.read<ProductProvider>().favoriteProduct(product);
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
