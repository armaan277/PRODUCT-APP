import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_app/model/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isProductLoading = true;

  List<Product> bagProducts = [];

  List<Product> favoriteProducts = [];

  int bagProductscount = 0;

  String select = '';

  String selectSize = '';

  Future<void> getProducts() async {
    Response response = await get(Uri.parse('https://dummyjson.com/products'));

    final mapResponse = jsonDecode(response.body);

    final mapResponseList = mapResponse['products'];

    for (int i = 0; i < mapResponseList.length; i++) {
      products.add(Product.fromMap(mapResponseList[i]));
      debugPrint('products : $products');
    }
    isProductLoading = false;
    notifyListeners();
  }

  void productInfoInc(Product product) {
    product.productInfoIncValue++;
    notifyListeners();
  }

  void productInfoDec(Product product) {
    if (product.productInfoIncValue > 1) {
      product.productInfoIncValue--;
    }
    notifyListeners();
  }

  void bagProductscountsInc() {
    bagProductscount++;
    notifyListeners();
  }

  void bagProductscountsDec() {
    bagProductscount--;
    notifyListeners();
  }

  void removeProductFromBag(int index) {
    bagProducts.removeAt(index);
    notifyListeners();
  }

  void removeProductFromFavorite(int index) {
    favoriteProducts.removeAt(index);
    notifyListeners();
  }

  void favoriteProduct(Product product) {
    if (!favoriteProducts.contains(product)) {
      favoriteProducts.add(product);
    } else {
      favoriteProducts.remove(product);
    }
    notifyListeners();
  }

  void favoriteChip(String favoriteChip) {
    select = favoriteChip;
    notifyListeners();
  }

  void selectSizes(String newSize) {
    selectSize = newSize;
    notifyListeners();
  }
}








// Widget buildFavoriteProductListView(BuildContext context) {
//     final providerWatch = context.watch<ProductProvider>();
//     final providerRead = context.read<ProductProvider>();
//     final favoritesAll = providerWatch.favoriteProducts;
//     final favorites = providerWatch.select.isEmpty
//         ? favoritesAll
//         : providerWatch.favoriteProducts
//             .where((favorite) => favorite.category == providerWatch.select)
//             .toList();
//     return ListView.builder(
//       itemCount: favorites.length,
//       itemBuilder: (context, index) {
//         final product = favorites[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 2,
//                   blurRadius: 2,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 10.0),
//                   child: Image.network(
//                     product.thumbnail,
//                     width: 125.0,
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 10),
//                       RichText(
//                         text: TextSpan(
//                           text: 'Brand: ',
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: product.brand,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.0),
//                         child: Text(
//                           product.title,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 50),
//                       Text(
//                         '\$ ${product.price}',
//                         style: const TextStyle(
//                           fontSize: 15,
//                           color: AppColor.appColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.0),
//                         child: Text(
//                           product.rating > 4.50
//                               ? '⭐⭐⭐⭐⭐'
//                               : product.rating > 4
//                                   ? '⭐⭐⭐⭐'
//                                   : product.rating > 3
//                                       ? '⭐⭐⭐'
//                                       : product.rating > 2
//                                           ? '⭐⭐'
//                                           : product.rating > 1
//                                               ? '⭐'
//                                               : '',
//                         ),
//                       ),
//                       Text(
//                         product.warrantyInformation,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     providerRead.removeProductFromFavorite(index,
//                         providerWatch.select.isEmpty ? favoritesAll : favorites);
//                   },
//                   icon: const Icon(Icons.close),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }



  // void removeProductFromFavorite(int index,List<Product> favorites) {
  //   favorites.removeAt(index);
  //   notifyListeners();
  // }