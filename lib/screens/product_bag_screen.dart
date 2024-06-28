import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class ProductBag extends StatefulWidget {
  const ProductBag({
    super.key,
  });

  @override
  State<ProductBag> createState() => _ProductBagState();
}

class _ProductBagState extends State<ProductBag> {
  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          'My Bag',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: providerWatch.bagProducts.isEmpty
          ? const Center(
              child: Text(
                'Bag is Empty !!!',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 4.0),
              itemCount: providerWatch.bagProducts.length,
              itemBuilder: (context, index) {
                final product = providerWatch.bagProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 8.0,
                  ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Image.network(
                              product.thumbnail,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 4.0,
                                ),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Brand : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: product.brand,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Text(
                                'Size: S',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.add,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$ ${product.price}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                product.returnPolicy,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          color: Colors.white,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                if (!providerWatch.favoriteProducts
                                    .contains(product)) {
                                  providerWatch.favoriteProducts.add(product);
                                } else {
                                  providerWatch.favoriteProducts
                                      .remove(product);
                                }
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    !providerWatch.favoriteProducts
                                            .contains(product)
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Favorites',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                providerRead.removeProductFromBag(index);
                                providerRead.bagProductscountsDec();
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
