import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/product_provider.dart';

import 'widgets/bottom_navigation_bar.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomNavigation(),  
      ),
    );
  }
}
