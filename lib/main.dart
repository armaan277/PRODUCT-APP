import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/app.dart';

bool isLoggedIn = false;
String userUniqueId = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  debugPrint('isLoggedIn : $isLoggedIn');
  userUniqueId = prefs.getString('userUniqueId')!;
  debugPrint('userUniqueId : $userUniqueId');

  runApp(
    const ProductApp(),
  );
}
