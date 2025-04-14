import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/screens/favourite_screen.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/profile_screen.dart';
import 'package:shopping_app/screens/shop_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

  @override
  void initState() {
    context.read<ProductProvider>().getProducts();
    context.read<ProductProvider>().getCartsData(userUniqueId);
    context.read<ProductProvider>().getFavouriteData(userUniqueId);
    context.read<ProductProvider>().getAddressData();
    context.read<ProductProvider>().getUserReviews(userUniqueId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: switch (selectedIndex) {
        0 => HomeScreen(),
        1 => ShopScreen(),
        2 => FavouriteScreen(),
        3 => ProfileScreen(),
        _ => Scaffold(
            body: Center(
              child: Text('Not Found Screen'),
            ),
          )
      },
      // body: IndexedStack(
      //   index: selectedIndex,
      //   children: const [
      //     HomeScreen(),
      //     ShopScreen(),
      //     FavouriteScreen(),
      //     ProfileScreen(),
      //   ],
      // ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: AppColor.appColor.withOpacity(0.2),
        elevation: 10.0,
        backgroundColor: Colors.white,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          selectedIndex = value;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
            selectedIcon: Icon(
              Icons.home,
              color: AppColor.appColor,
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
            selectedIcon: Icon(
              Icons.shopping_cart,
              color: AppColor.appColor,
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
            selectedIcon: Icon(
              Icons.favorite,
              color: AppColor.appColor,
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Person',
            selectedIcon: Icon(
              Icons.person,
              color: AppColor.appColor,
            ),
          ),
        ],
      ),
    );
  }
}
