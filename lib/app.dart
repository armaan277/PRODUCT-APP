import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/login_screen.dart';
import 'package:shopping_app/screens/my_orders_sceen.dart';
import 'package:shopping_app/screens/order_success_screen.dart';
import 'package:shopping_app/screens/otp_screen.dart';
import 'package:shopping_app/screens/product_cart_screen.dart';
import 'package:shopping_app/widgets/bottom_navigation_bar.dart';

import 'screens/otp_sent_forget_screen.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColor.appColor,
          ),
        ),
        initialRoute: isLoggedIn ? 'bottom_navigation' : 'login_sreen',
        routes: {
          'bottom_navigation': (context) => const BottomNavigation(),
          'login_sreen': (context) => const LogInScreen(),
          'product_cart_screen': (context) => const ProductCartScreen(),
          'my_orders_screen': (context) => const MyOrdersScreen(),
          'order_success_screen': (context) => const OrderSuccessScreen(),
          'otp_screen': (context) => const OTPScreen(), // Added / here
          'otp_sent_forget_screen': (context) => const OTPSentForgetScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
