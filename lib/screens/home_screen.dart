import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import '../widgets/build_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final carouselController = CarouselSliderController();

  List<String> images = [
    'images/beauty_offer_img.avif',
    'images/shoes_offer_img.avif',
    'images/fashion_offer_img.avif'
  ];

  final searchProductsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
//    final searchProducts = providerWatch.products.where(
//   (product) => product.title.toLowerCase().contains(
//         searchProductsController.text.toLowerCase(),
//       ),
// ).toList();

    return Scaffold(
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
      drawer: const AppDrawer(),
      backgroundColor: AppColor.appBackgroundColor,
      body: providerWatch.isProductLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColor.appColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchProductsController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search, size: 28),
                        ),
                        onChanged: (value) {
                          // setState(() {
                          //   searchProducts = value;
                          // });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    CarouselSlider(
                      items: images.map((image) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        autoPlay: true,
                      ),
                      carouselController: carouselController,
                    ),
                    Center(
                      child: DotsIndicator(
                        dotsCount: images.length,
                        position: currentIndex,
                        decorator: DotsDecorator(
                          color: Colors.grey,
                          activeColor: AppColor.appColor,
                          size: const Size.square(9.0),
                          activeSize: const Size(12.0, 12.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onTap: (index) {
                          carouselController.animateToPage(index);
                        },
                      ),
                    ),
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
