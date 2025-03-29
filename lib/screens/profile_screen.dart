import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/my_orders_sceen.dart';
import 'package:shopping_app/screens/my_reviews_screen.dart';
import 'package:shopping_app/widgets/profile_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  final Product? product;
  const ProfileScreen({
    super.key,
    this.product,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    final providerRead = context.read<ProductProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      providerRead.getUserDetails(userUniqueId);
      providerRead.fetchOrders(userUniqueId, context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: Text(
          'My Profile',
          style: GoogleFonts.pacifico(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'product_cart_screen');
            },
            icon: Badge(
              backgroundColor: Colors.white,
              label: Text(
                '${providerWatch.bagProductsCount}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColor.appBackgroundColor,
      body: providerWatch.userDetails.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.appColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 44,
                        child: Text(
                          providerRead.newName(
                              providerRead.userDetails.first['name'] ?? ''),
                          style: const TextStyle(
                            fontSize: 40,
                            color: AppColor.appColor,
                          ),
                        ),
                        // backgroundImage: NetworkImage(
                        //   'https://avatars.githubusercontent.com/u/108656142?v=4',
                        // ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              providerRead.userDetails.first['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              providerRead.userDetails.first['email'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  ProfileListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MyOrdersScreen();
                          },
                        ),
                      );
                    },
                    leading: Icon(Icons.shopping_cart_sharp),
                    title: 'My Orders',
                    subTitle:
                        'Already have ${providerWatch.orders.length} orders',
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(),
                  ProfileListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MyReviewsScreen();
                      }));
                    },
                    leading: const Icon(Icons.reviews),
                    title: 'My Reviews',
                    subTitle:
                        'Reviews for ${providerWatch.userReviews.length} items',
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(),
                ],
              ),
            ),
    );
  }
}
