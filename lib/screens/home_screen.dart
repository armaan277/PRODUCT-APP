import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import '../widgets/build_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          'Shopping App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'product_cart_screen');
            },
            icon: Badge(
              backgroundColor: Colors.black,
              label: Text('${providerWatch.bagProductscount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColor.appBackgroundColor,
      body: providerWatch.isProductLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColor.appColor,
              ),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildProducts(
                      title: 'Beauty',
                      productCategory: 'beauty',
                    ),
                    BuildProducts(
                      title: 'Fragrances',
                      productCategory: 'fragrances',
                    ),
                    BuildProducts(
                      title: 'Furniture',
                      productCategory: 'furniture',
                    ),
                    BuildProducts(
                      title: 'Groceries',
                      productCategory: 'groceries',
                    ),
                    BuildProducts(
                      title: 'Home Decoration',
                      productCategory: 'home-decoration',
                    ),
                    BuildProducts(
                      title: 'Kitchen Accessories',
                      productCategory: 'kitchen-accessories',
                    ),
                    BuildProducts(
                      title: 'Laptops',
                      productCategory: 'laptops',
                    ),
                    BuildProducts(
                      title: 'Mens Shirts',
                      productCategory: 'mens-shirts',
                    ),
                    BuildProducts(
                      title: 'Mens Shoes',
                      productCategory: 'mens-shoes',
                    ),
                    BuildProducts(
                      title: 'Mens Watches',
                      productCategory: 'mens-watches',
                    ),
                    BuildProducts(
                      title: 'Mobile Accessories',
                      productCategory: 'mobile-accessories',
                    ),
                    BuildProducts(
                      title: 'Motorcycle',
                      productCategory: 'motorcycle',
                    ),
                    BuildProducts(
                      title: 'Skin Care',
                      productCategory: 'skin-care',
                    ),
                    BuildProducts(
                      title: 'Smartphones',
                      productCategory: 'smartphones',
                    ),
                    BuildProducts(
                      title: 'Sports Accessories',
                      productCategory: 'sports-accessories',
                    ),
                    BuildProducts(
                      title: 'Sunglasses',
                      productCategory: 'sunglasses',
                    ),
                    BuildProducts(
                      title: 'Tablets',
                      productCategory: 'tablets',
                    ),
                    BuildProducts(
                      title: 'Tops',
                      productCategory: 'tops',
                    ),
                    BuildProducts(
                      title: 'Vehicle',
                      productCategory: 'vehicle',
                    ),
                    BuildProducts(
                      title: 'Womens Bags',
                      productCategory: 'womens-bags',
                    ),
                    BuildProducts(
                      title: 'Womens Dresses',
                      productCategory: 'womens-dresses',
                    ),
                    BuildProducts(
                      title: 'Womens Jewellery',
                      productCategory: 'womens-jewellery',
                    ),
                    BuildProducts(
                      title: 'Womens Shoes',
                      productCategory: 'womens-shoes',
                    ),
                    BuildProducts(
                      title: 'Womens Watches',
                      productCategory: 'womens-watches',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
