import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/product_bag_screen.dart';
import 'package:shopping_app/screens/product_info_screen.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/widgets/favorite_container.dart';
import 'package:shopping_app/widgets/filter_product_container.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

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
        : Scaffold(
            backgroundColor: AppColor.appBackgroundColor,
            appBar: AppBar(
              leading: Icon(Icons.arrow_back),
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ProductBag();
                    }));
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
                          select:
                              providerWatch.selectShopCategories == 'fragrances'
                                  ? 'select'
                                  : '',
                          onTap: () {
                            providerRead.shopChip('fragrances');
                          },
                        ),
                        FavoriteContainer(
                          title: 'Furniture',
                          select:
                              providerWatch.selectShopCategories == 'furniture'
                                  ? 'select'
                                  : '',
                          onTap: () {
                            providerRead.shopChip('furniture');
                          },
                        ),
                        FavoriteContainer(
                          title: 'Groceries',
                          select:
                              providerWatch.selectShopCategories == 'groceries'
                                  ? 'select'
                                  : '',
                          onTap: () {
                            providerRead.shopChip('groceries');
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
                    providerRead
                        .sortProductsByPriceHighToLow(providerWatch.products);
                    Navigator.of(context).pop();
                  },
                  onTapLTH: () {
                    providerRead.selectFilterationsShop('Low To High');
                    providerRead
                        .sortProductsByPriceLowToHigh(providerWatch.products);
                    Navigator.of(context).pop();
                  },
                  onTapBR: () {
                    providerRead.selectFilterationsShop('Best Rating');
                    providerRead
                        .sortProductsByBestRating(providerWatch.products);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: buildShopProductGridView(context),
                ),
              ],
            ),
          );
  }

  Widget buildShopProductGridView(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();

    final shopCategories = providerWatch.products
        .where((ele) => ele.category == providerWatch.selectShopCategories)
        .toList();

    return providerWatch.selectShopCategories == ''
        ? GridView.builder(
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
                              child: Center(
                                child: product.id == 6 ||
                                        product.id == 9 ||
                                        product.id == 19
                                    ? Image(
                                        image: NetworkImage(
                                          product.images.first,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: NetworkImage(
                                          product.thumbnail,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
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
                              child: Center(
                                child: product.id == 6 ||
                                        product.id == 9 ||
                                        product.id == 19
                                    ? Image(
                                        image: NetworkImage(
                                          product.images.first,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: NetworkImage(
                                          product.thumbnail,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
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
