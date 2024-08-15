import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import 'package:shopping_app/widgets/favorite_container.dart';
import 'package:shopping_app/widgets/filter_product_container.dart';
import '../widgets/build_favourite_product.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          'Favorites Products',
          style: GoogleFonts.pacifico(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProductCartScreen();
              }));
            },
            icon: Badge(
              backgroundColor: Colors.white,
              label: Text(
                '${providerWatch.bagProductsCount}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
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
                    select: providerWatch.selectFavoriteCategories == ''
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Beauty',
                    select: providerWatch.selectFavoriteCategories == 'beauty'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('beauty');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Fragrances',
                    select:
                        providerWatch.selectFavoriteCategories == 'fragrances'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('fragrances');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Furniture',
                    select:
                        providerWatch.selectFavoriteCategories == 'furniture'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('furniture');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Groceries',
                    select:
                        providerWatch.selectFavoriteCategories == 'groceries'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('groceries');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Home Decoration',
                    select: providerWatch.selectFavoriteCategories ==
                            'home-decoration'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('home-decoration');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Kitchen Accessories',
                    select: providerWatch.selectFavoriteCategories ==
                            'kitchen-accessories'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('kitchen-accessories');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Laptops',
                    select: providerWatch.selectFavoriteCategories == 'laptops'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('laptops');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mens Shirts',
                    select:
                        providerWatch.selectFavoriteCategories == 'mens-shirts'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('mens-shirts');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mens Shoes',
                    select:
                        providerWatch.selectFavoriteCategories == 'mens-shoes'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('mens-shoes');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mens Watches',
                    select:
                        providerWatch.selectFavoriteCategories == 'mens-watches'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('mens-watches');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mobile Accessories',
                    select: providerWatch.selectFavoriteCategories ==
                            'mobile-accessories'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('mobile-accessories');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Motorcycle',
                    select:
                        providerWatch.selectFavoriteCategories == 'motorcycle'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('motorcycle');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Skin Care',
                    select:
                        providerWatch.selectFavoriteCategories == 'skin-care'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('skin-care');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Smartphones',
                    select:
                        providerWatch.selectFavoriteCategories == 'smartphones'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('smartphones');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Sports Accessories',
                    select: providerWatch.selectFavoriteCategories ==
                            'sports-accessories'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('sports-accessories');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Sunglasses',
                    select:
                        providerWatch.selectFavoriteCategories == 'sunglasses'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('sunglasses');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Tablets',
                    select: providerWatch.selectFavoriteCategories == 'tablets'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('tablets');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Tops',
                    select: providerWatch.selectFavoriteCategories == 'tops'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('tops');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Vehicle',
                    select: providerWatch.selectFavoriteCategories == 'vehicle'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('vehicle');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Bags',
                    select:
                        providerWatch.selectFavoriteCategories == 'womens-bags'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('womens-bags');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Dresses',
                    select: providerWatch.selectFavoriteCategories ==
                            'womens-dresses'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('womens-dresses');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Jewellery',
                    select: providerWatch.selectFavoriteCategories ==
                            'womens-jewellery'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('womens-jewellery');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Shoes',
                    select:
                        providerWatch.selectFavoriteCategories == 'womens-shoes'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.favoriteChip('womens-shoes');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Watches',
                    select: providerWatch.selectFavoriteCategories ==
                            'womens-watches'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.favoriteChip('womens-watches');
                    },
                  ),
                ],
              ),
            ),
          ),
          if (providerRead.favoriteProducts.isNotEmpty)
            FilterProductContainer(
              price: providerWatch.selectFilterationFavorite,
              onTapHTL: () {
                providerRead.selectFilterationsFavorite('High To Low');
                providerRead.sortProductsByPriceHighToLow(
                    providerWatch.favoriteProducts);
                Navigator.of(context).pop();
              },
              onTapLTH: () {
                providerRead.selectFilterationsFavorite('Low To High');
                providerRead.sortProductsByPriceLowToHigh(
                    providerWatch.favoriteProducts);
                Navigator.of(context).pop();
              },
              onTapBR: () {
                providerRead.selectFilterationsFavorite('Best Rating');
                providerRead
                    .sortProductsByBestRating(providerWatch.favoriteProducts);
                Navigator.of(context).pop();
              },
            ),
          const Expanded(
            child: BuildFavouriteProduct(),
          ),
        ],
      ),
    );
  }
}
