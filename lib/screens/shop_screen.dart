import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/widgets/build_gridview_products.dart';
import 'package:shopping_app/widgets/favorite_container.dart';
import 'package:shopping_app/widgets/filter_product_container.dart';


class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          'Big Sales',
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
      drawer: AppDrawer(),
      body: Column(
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
                    select: providerWatch.selectShopCategories == ''
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Beauty',
                    select: providerWatch.selectShopCategories == 'beauty'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('beauty');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Fragrances',
                    select: providerWatch.selectShopCategories == 'fragrances'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('fragrances');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Furniture',
                    select: providerWatch.selectShopCategories == 'furniture'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('furniture');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Groceries',
                    select: providerWatch.selectShopCategories == 'groceries'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('groceries');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Home Decoration',
                    select:
                        providerWatch.selectShopCategories == 'home-decoration'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.shopChip('home-decoration');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Kitchen Accessories',
                    select: providerWatch.selectShopCategories ==
                            'kitchen-accessories'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('kitchen-accessories');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Laptops',
                    select: providerWatch.selectShopCategories == 'laptops'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('laptops');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mens Shirts',
                    select: providerWatch.selectShopCategories == 'mens-shirts'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('mens-shirts');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mens Shoes',
                    select: providerWatch.selectShopCategories == 'mens-shoes'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('mens-shoes');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mens Watches',
                    select: providerWatch.selectShopCategories == 'mens-watches'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('mens-watches');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Mobile Accessories',
                    select: providerWatch.selectShopCategories ==
                            'mobile-accessories'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('mobile-accessories');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Motorcycle',
                    select: providerWatch.selectShopCategories == 'motorcycle'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('motorcycle');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Skin Care',
                    select: providerWatch.selectShopCategories == 'skin-care'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('skin-care');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Smartphones',
                    select: providerWatch.selectShopCategories == 'smartphones'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('smartphones');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Sports Accessories',
                    select: providerWatch.selectShopCategories ==
                            'sports-accessories'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('sports-accessories');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Sunglasses',
                    select: providerWatch.selectShopCategories == 'sunglasses'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('sunglasses');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Tablets',
                    select: providerWatch.selectShopCategories == 'tablets'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('tablets');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Tops',
                    select: providerWatch.selectShopCategories == 'tops'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('tops');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Vehicle',
                    select: providerWatch.selectShopCategories == 'vehicle'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('vehicle');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Bags',
                    select: providerWatch.selectShopCategories == 'womens-bags'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('womens-bags');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Dresses',
                    select:
                        providerWatch.selectShopCategories == 'womens-dresses'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.shopChip('womens-dresses');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Jewellery',
                    select:
                        providerWatch.selectShopCategories == 'womens-jewellery'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.shopChip('womens-jewellery');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Shoes',
                    select: providerWatch.selectShopCategories == 'womens-shoes'
                        ? 'select'
                        : '',
                    onTap: () {
                      providerRead.shopChip('womens-shoes');
                    },
                  ),
                  FavoriteContainer(
                    title: 'Womens Watches',
                    select:
                        providerWatch.selectShopCategories == 'womens-watches'
                            ? 'select'
                            : '',
                    onTap: () {
                      providerRead.shopChip('womens-watches');
                    },
                  ),
                ],
              ),
            ),
          ),
          FilterProductContainer(
            price: providerWatch.selectFilterationShop,
            onTapHTL: () {
              providerRead.selectFilterationsShop('High To Low');
              providerRead.sortProductsByPriceHighToLow(providerWatch.products);
              Navigator.of(context).pop();
            },
            onTapLTH: () {
              providerRead.selectFilterationsShop('Low To High');
              providerRead.sortProductsByPriceLowToHigh(providerWatch.products);
              Navigator.of(context).pop();
            },
            onTapBR: () {
              providerRead.selectFilterationsShop('Best Rating');
              providerRead.sortProductsByBestRating(providerWatch.products);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 10),
          const Expanded(
            child: BuildGridviewProducts(),
          ),
        ],
      ),
    );
  }
}
