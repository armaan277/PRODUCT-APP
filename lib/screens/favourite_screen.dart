import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import '../widgets/build_favourite_product.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
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
                '${providerWatch.bagProducts.length}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColor.appBackgroundColor,
      body: BuildFavouriteProduct(),
    );
  }
}
