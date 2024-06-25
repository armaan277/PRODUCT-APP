import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/favourite_screen.dart';
import 'package:shopping_app/home_screen.dart';
import 'package:shopping_app/product_provider.dart';
import 'package:shopping_app/profile_screen.dart';
import 'package:shopping_app/shop_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

  void selectedIndexWidget(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    context.read<ProductProvider>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor: Color(0xffDB3022),
        title: Text(
          'Shopping App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_bag_outlined),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(),
      body: selectedWidget(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectedIndexWidget,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xffDB3022),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            label: 'Shop',
            icon: Badge(
              label: Text('0'),
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'favourites',
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
    );
  }

  Widget selectedWidget(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return ShopScreen();
      case 2:
        return FavouriteScreen();
      case 3:
        return ProfileScreen();
      default:
        return Text('Default');
    }
  }
}
