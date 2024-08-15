import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/login_screen.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import 'package:shopping_app/widgets/bottom_navigation_bar.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        initialRoute: isLoggedIn ? 'bottom_navigation' : 'login_sreen',
        routes: {
          'bottom_navigation': (context) => const BottomNavigation(),
          'login_sreen': (context) => const LogInScreen(),
          'product_cart_screen': (context) => const ProductCartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
