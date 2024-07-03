import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.appColor,
                  Colors.red.shade300,
                ],
              ),
            ),
            height: 240,
            width: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(54),
                    ),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundImage:
                          ExactAssetImage('assets/images/armaan.png'),
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Khan Armaan',
                    style: TextStyle(
                      letterSpacing: 1.1,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: AppColor.appColor,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('home_screen');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_bag,
              color: AppColor.appColor,
            ),
            title: Text(
              'My Bag',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: AppColor.appColor,
            ),
            title: Text(
              'Favorite Products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: AppColor.appColor,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.help,
              color: AppColor.appColor,
            ),
            title: Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: AppColor.appColor,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
