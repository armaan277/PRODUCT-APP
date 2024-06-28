import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/favourite_screen.dart';
import 'package:shopping_app/screens/home_screen.dart';
import 'package:shopping_app/screens/product_bag_screen.dart';
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

  // void selectedIndexWidget(int index) {
  //   setState(() {
  //     selectedIndex = index;
  //   });
  // }

  @override
  void initState() {
    context.read<ProductProvider>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          'Shopping App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
      drawer: const Drawer(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomeScreen(),
          ShopScreen(),
          FavouriteScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          selectedIndex = value;
          setState(() {});
        },
        destinations: [
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

      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: selectedIndexWidget,
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: selectedIndex,
      //   selectedItemColor: AppColor.appColor,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.home,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Shop',
      //       icon: Badge(
      //         label: Text('0'),
      //         child: Icon(
      //           Icons.shopping_cart,
      //         ),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.favorite,
      //       ),
      //       label: 'favourites',
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         Icons.person,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  // Widget selectedWidget(int index) {
  //   switch (index) {
  //     case 0:
  //       return const HomeScreen();
  //     case 1:
  //       return const ShopScreen();
  //     case 2:
  //       return const FavouriteScreen();
  //     case 3:
  //       return const ProfileScreen();
  //     default:
  //       return const Text('Default');
  //   }
  // }
}
