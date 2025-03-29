import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/app.dart';
import 'package:shopping_app/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// My Reviews -> Reviews for items static items
bool isLoggedIn = false;
String userUniqueId = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://qackrunhjegacjcljwyn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFhY2tydW5oamVnYWNqY2xqd3luIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyMjM3MzUsImV4cCI6MjA1Mjc5OTczNX0.8cE6tVTN8YTCpC3OvMppuxVTi3L43ywP-ES_v0S7VgA',
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  debugPrint('isLoggedIn : $isLoggedIn');
  userUniqueId = prefs.getString('userUniqueId') ?? '';
  debugPrint('userUniqueId : $userUniqueId');

  runApp(
    const ProductApp(),
  );
}
