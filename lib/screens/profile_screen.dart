import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/product_bag_screen.dart';
import 'package:shopping_app/widgets/profile_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
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
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                CircleAvatar(
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
                      Text(
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
            SizedBox(height: 15),
            ProfileListTile(
              leading: Icon(Icons.shopping_cart_sharp),
              title: 'My Orders',
              subTitle: 'Already have 7 orders',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ProfileListTile(
              leading: Icon(Icons.location_on),
              title: 'Shopping addresses',
              subTitle: '3 addresses',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ProfileListTile(
              leading: Icon(Icons.payment),
              title: 'Payment methods',
              subTitle: 'Visa **34',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ProfileListTile(
              leading: Icon(Icons.reviews),
              title: 'My Reviews',
              subTitle: 'Reviews for 4 items',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ProfileListTile(
              leading: Icon(Icons.reviews),
              title: 'Settings',
              subTitle: 'Notifications, password',
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
