import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/address_screen.dart';
import 'package:shopping_app/widgets/favorite_container.dart';

class ProductCartScreen extends StatefulWidget {
  const ProductCartScreen({
    super.key,
  });

  @override
  State<ProductCartScreen> createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  @override
  void initState() {
    context.read<ProductProvider>().setSFProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'My Bag',
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: providerWatch.bagProducts.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/bag_empty.png'),
              ],
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: providerWatch.bagProducts.length,
              itemBuilder: (context, index) {
                final product = providerWatch.bagProducts[index];
                final isFavorite =
                    providerWatch.favoriteProducts.contains(product);
                // final favorite =
                //     !providerWatch.favoriteProducts.contains(product);
                return Slidable(
                  key: ValueKey(product.id), // Ensure this is unique
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          providerRead.favoriteProduct(product);
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.appColor,
                        icon:
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: isFavorite ? 'Favorite' : 'Unfavorite',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          providerRead.removeProductFromBag(index);
                          providerRead.bagProductscountsDec();
                        },
                        foregroundColor: AppColor.appColor,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 140,
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
                                  top: 24.0,
                                  bottom: 4.0,
                                ),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Brand : ',
                                  style: TextStyle(
                                    color: Color(0xffe5e5e5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffF3F3F3),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 16,
                                              child: IconButton(
                                                onPressed: () {
                                                  providerRead
                                                      .productInfoDec(product);
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14.0,
                                              ),
                                              child: Text(
                                                '${product.productInfoIncValue}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 16,
                                              child: IconButton(
                                                onPressed: () {
                                                  providerRead
                                                      .productInfoInc(product);
                                                },
                                                icon: const Icon(
                                                  color: Colors.black,
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '${product.price}',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Text(
                              //   product.returnPolicy,
                              //   style: const TextStyle(
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // PopupMenuButton(
                        //   color: Colors.white,
                        //   itemBuilder: (context) => [
                        //     PopupMenuItem(
                        //       onTap: () {
                        //         providerRead.favoriteProduct(product);
                        //       },
                        //       child: Row(
                        //         children: [
                        //           Icon(
                        //             favorite
                        //                 ? Icons.favorite_border
                        //                 : Icons.favorite,
                        //             color: Colors.red,
                        //           ),
                        //           const SizedBox(width: 5),
                        //           const Text(
                        //             'Favorites',
                        //             style: TextStyle(
                        //               color: Colors.black54,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     PopupMenuItem(
                        //       onTap: () {
                        //         providerRead.removeProductFromBag(index);
                        //         providerRead.bagProductscountsDec();
                        //       },
                        //       child: const Row(
                        //         children: [
                        //           Icon(
                        //             Icons.delete,
                        //             color: Colors.black54,
                        //           ),
                        //           SizedBox(width: 5),
                        //           Text(
                        //             'Delete',
                        //             style: TextStyle(
                        //               color: Colors.black54,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your promo code',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total amount:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      '${providerWatch.totalPrice.toStringAsFixed(2)}\$',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddressScreen();
                  }));
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(bottom: 20.0),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    color: AppColor.appColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                    child: Text(
                      'CHECK OUT',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shopping_app/constant/constant.dart';
// import 'package:shopping_app/product_provider/product_provider.dart';

// class ProductCartScreen extends StatefulWidget {
//   const ProductCartScreen({
//     super.key,
//   });

//   @override
//   State<ProductCartScreen> createState() => _ProductCartScreenState();
// }

// class _ProductCartScreenState extends State<ProductCartScreen> {
//   @override
//   void initState() {
//     context.read<ProductProvider>().setSFProducts();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final providerWatch = context.watch<ProductProvider>();
//     final providerRead = context.read<ProductProvider>();
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),
//       appBar: AppBar(
//         backgroundColor: AppColor.appColor,
//         title: Text('My Bag',
//             style: GoogleFonts.pacifico(
//               color: Colors.white,
//             )),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: providerWatch.bagProducts.isEmpty
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('assets/bag_empty.png'),
//               ],
//             )
//           : ListView.separated(
//               separatorBuilder: (context, index) => const SizedBox(height: 4.0),
//               itemCount: providerWatch.bagProducts.length,
//               itemBuilder: (context, index) {
//                 final product = providerWatch.bagProducts[index];
//                 final favorite =
//                     !providerWatch.favoriteProducts.contains(product);
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10.0,
//                     vertical: 8.0,
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 2,
//                           blurRadius: 2,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 140,
//                           width: 140,
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 10.0),
//                             child: Image.network(
//                               product.images.first,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 12.0,
//                                   bottom: 4.0,
//                                 ),
//                                 child: Text(
//                                   overflow: TextOverflow.ellipsis,
//                                   product.title,
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               RichText(
//                                 text: TextSpan(
//                                   text: 'Brand : ',
//                                   style: const TextStyle(
//                                     color: Colors.black87,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: product.brand,
//                                       style: const TextStyle(
//                                         color: Colors.black54,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 12.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             providerRead
//                                                 .productInfoDec(product);
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             child: const Padding(
//                                               padding: EdgeInsets.all(4.0),
//                                               child: Icon(
//                                                 Icons.remove,
//                                                 size: 18,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 8.0,
//                                           ),
//                                           child: Text(
//                                             providerWatch.bagProducts[index]
//                                                 .productInfoIncValue
//                                                 .toString(),
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             providerRead
//                                                 .productInfoInc(product);
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             child: const Padding(
//                                               padding: EdgeInsets.all(4.0),
//                                               child: Icon(
//                                                 Icons.add,
//                                                 size: 18,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Text(
//                                       '\$ ${product.price}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(
//                                 product.returnPolicy,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         PopupMenuButton(
//                           color: Colors.white,
//                           itemBuilder: (context) => [
//                             PopupMenuItem(
//                               onTap: () {
//                                 providerRead.favoriteProduct(product);
//                               },
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     favorite
//                                         ? Icons.favorite_border
//                                         : Icons.favorite,
//                                     color: Colors.red,
//                                   ),
//                                   const SizedBox(width: 5),
//                                   const Text(
//                                     'Favorites',
//                                     style: TextStyle(
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             PopupMenuItem(
//                               onTap: () {
//                                 providerRead.removeProductFromBag(index);
//                                 providerRead.bagProductscountsDec();
//                               },
//                               child: const Row(
//                                 children: [
//                                   Icon(
//                                     Icons.delete,
//                                     color: Colors.black54,
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     'Delete',
//                                     style: TextStyle(
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
