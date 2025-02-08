import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    context.read<ProductProvider>().getUserDetails(userUniqueId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductProvider>();
    final providerRead = context.read<ProductProvider>();
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
            height: 260,
            width: double.infinity,
            child: SafeArea(
              child: providerWatch.isUserDetailsLoad
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(54),
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColor.appBackgroundColor,
                            radius: 50,
                            // backgroundImage: ExactAssetImage('assets/armaan.png'),
                            child: Text(
                              providerRead.userDetails.isNotEmpty
                                  ? providerRead.newName(
                                      providerRead.userDetails.first['name'])
                                  : 'GU',
                              style: TextStyle(
                                fontSize: 40,
                                color: AppColor.appColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          providerRead.userDetails.isNotEmpty
                              ? providerRead.userDetails.first['name']
                              : 'Guest User',
                          style: GoogleFonts.pacifico(
                            letterSpacing: 1.1,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          providerRead.userDetails.isNotEmpty
                              ? providerRead.userDetails.first['email']
                              : 'guest@gmail.com',
                          style: TextStyle(
                            letterSpacing: 1.1,
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
          const Divider(),
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
