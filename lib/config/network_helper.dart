import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHelper {
  static const String baseUrl = 'http://192.168.0.104:3000';

  static Future<dynamic> get(
      String endpoint, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'API Response ($endpoint): ${response.statusCode} - ${response.body}');
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 403 || response.statusCode == 401) {
        if (responseBody['redirectToLogin'] == true) {
          debugPrint('Token invalid/expired, redirecting to login');
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear(); // Clear token and other data
          Navigator.of(context).pushReplacementNamed('login_sreen');
          return null; // Exit early
        }
      }

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        debugPrint(
            'Failed to fetch data: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Network Error ($endpoint): $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> delete(
    String endpoint,
    String token,
    BuildContext context,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'API Response ($endpoint): ${response.statusCode} - ${response.body}');
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 403 || response.statusCode == 401) {
        if (responseBody['redirectToLogin'] == true) {
          debugPrint('Token invalid/expired, redirecting to login');
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.of(context).pushReplacementNamed('login_sreen');
          return null;
        }
      }

      return {
        'statusCode': response.statusCode,
        'body': responseBody,
      };
    } catch (e) {
      debugPrint('Network Error ($endpoint): $e');
      return null;
    }
  }
}
