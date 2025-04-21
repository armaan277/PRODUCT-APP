import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
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
              child: providerWatch.userDetails.isEmpty
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
                              // providerRead.userDetails.isNotEmpty
                              providerRead.newName(
                                  providerRead.userDetails.first['name']),
                              style: TextStyle(
                                fontSize: 40,
                                color: AppColor.appColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          // providerRead.userDetails.isNotEmpty
                          providerRead.userDetails.first['name'],
                          style: GoogleFonts.pacifico(
                            letterSpacing: 1.1,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          providerRead.userDetails.first['email'],
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
              Icons.attach_money,
              color: AppColor.appColor,
            ),
            title: const Text(
              'Refund Policy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              _launchURL(
                'https://armaan277.github.io/simple-website/refund-policy.html',
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.help_outline,
              color: AppColor.appColor,
            ),
            title: const Text(
              'FAQs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              _launchURL(
                'https://armaan277.github.io/simple-website/FAQs.html',
              );
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
