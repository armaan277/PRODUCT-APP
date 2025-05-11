import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/product_info_screen.dart';
import 'package:shopping_app/widgets/products_card.dart';
import '../product_provider/product_provider.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final searchProductsController = TextEditingController();
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final shopCategories = providerWatch.selectShopCategories == ''
        ? providerWatch.products.where((ele) {
            return ele.title.toLowerCase().contains(
                  searchProductsController.text.toLowerCase(),
                );
          }).toList()
        : providerWatch.products
            .where(
              (ele) =>
                  ele.category == providerWatch.selectShopCategories &&
                  ele.title.toLowerCase().contains(
                        searchProductsController.text.toLowerCase(),
                      ),
            )
            .toList();
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          'Shopping App',
          style: GoogleFonts.pacifico(
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
              backgroundColor: Colors.white,
              label: Text(
                '${providerWatch.bagProducts.length}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: searchProductsController,
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, size: 24),
                suffixIcon: searchProductsController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            searchProductsController.clear();
                            isSearch = false;
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchProductsController.text = value;
                });
              },
            ),
          ),
          Expanded(
            child: shopCategories.isEmpty
                ? Center(
                    child: Image.asset(
                      'assets/products_not_found.png',
                      width: 300,
                    ),
                  )
                : GridView.builder(
                    itemCount: shopCategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        discountPercentage:
                            product.discountPercentage.toDouble(),
                        favorite: favorite,
                        onPressed: () {
                          context
                              .read<ProductProvider>()
                              .toggleFavoriteStatus(product,context);
                        },
                        vertical: 12.0,
                        horizontal: 12.0,
                        left: 150,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
