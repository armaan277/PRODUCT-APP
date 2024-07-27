import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_drawer.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/widgets/profile_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text(
          'My Profile',
          style: TextStyle(
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
              backgroundColor: Colors.black,
              label: Text('${providerWatch.bagProductscount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/108656142?v=4',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Khan Armaan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'khanarmaan@gmail.com',
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
            const ProfileListTile(
              leading: Icon(Icons.shopping_cart_sharp),
              title: 'My Orders',
              subTitle: 'Already have 7 orders',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ProfileListTile(
              leading: Icon(Icons.location_on),
              title: 'Shopping addresses',
              subTitle: '3 addresses',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ProfileListTile(
              leading: Icon(Icons.payment),
              title: 'Payment methods',
              subTitle: 'Visa **34',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ProfileListTile(
              leading: Icon(Icons.reviews),
              title: 'My Reviews',
              subTitle: 'Reviews for 4 items',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            const ProfileListTile(
              leading: Icon(Icons.reviews),
              title: 'Settings',
              subTitle: 'Notifications, password',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
