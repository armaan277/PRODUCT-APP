import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_app/constant/constant.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
          children: [
            // Centered content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Center vertically within Expanded
                children: [
                  SvgPicture.asset(
                    'assets/order_success.svg',
                    height: 200, // Adjust size
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Success!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Your order will be delivered soon.\nThank you for choosing our app!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Button at the bottom
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('bottom_navigation');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    bottom: 20.0,
                  ),
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
                      'CONTINUE SHOPPING',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
