import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.appBackgroundColor,
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
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(54),
                    ),
                    child: const CircleAvatar(
                      radius: 54,
                      backgroundImage: ExactAssetImage('assets/armaan.png'),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Khan Armaan',
                    style: GoogleFonts.pacifico(
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
            leading: const Icon(
              Icons.home,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('bottom_navigation');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart,
              color: AppColor.appColor,
            ),
            title: const Text(
              'My Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'my_orders_screen');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Favorite',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              // Navigator.pushNamed(context, 'favourite_screen');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              // Navigator.of(context).pushNamed('profile_screen');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.help,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              isLoggedIn = false;
              userUniqueId = '';
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', isLoggedIn);
              prefs.setString('userUniqueId', userUniqueId);
              Navigator.of(context).pushReplacementNamed('login_sreen');
            },
          ),
        ],
      ),
    );
  }
}
