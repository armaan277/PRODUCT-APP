import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/product_info_screen.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();

    return providerWatch.isProductLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColor.appColor,
            ),
          )
        : GridView.builder(
            itemCount: context.watch<ProductProvider>().products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(5.0),
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
                            color: Color(0xffF3F3F3),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductInfo(
                                        product: providerWatch.products[index],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Hero(
                                tag: providerWatch.products[index].thumbnail,
                                child: Image(
                                  image: NetworkImage(
                                    providerWatch.products[index].thumbnail,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${providerWatch.products[index].rating > 4.50 ? '⭐⭐⭐⭐' : providerWatch.products[index].rating > 4 ? '⭐⭐⭐⭐' : providerWatch.products[index].rating > 3 ? '⭐⭐⭐' : providerWatch.products[index].rating > 2 ? '⭐⭐' : providerWatch.products[index].rating > 1 ? '⭐' : ''}',
                                ),
                              ),
                              Text(
                                providerWatch.products[index].brand,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                providerWatch.products[index].title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$ ${providerWatch.products[index].price}',
                                style: TextStyle(
                                  color: AppColor.appColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 18.0),
                    width: 50,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColor.appColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        '-${providerWatch.products[index].discountPercentage.toInt()}%',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 175,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 22,
                          child: Icon(
                            Icons.favorite_border_outlined,
                            size: 30,
                            color: Colors.red,
                          ),
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
