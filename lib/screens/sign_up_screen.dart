import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:nanoid/nanoid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  // final String userId = nanoid(8);

  final nanoId = nanoid(8);
  late final uniqueId;

  Future<void> _sendOTP(String email) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.104:3000/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to send OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: AppColor.appBackgroundColor,
      ),
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Create Account',
                    style: TextStyle(
                        color: AppColor.appColor,
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text('Enter details to sign up',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: provider.signupNameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: provider.signupPhoneController,
                  decoration: const InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Phone is required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: provider.signupEmailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Email is required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: provider.signupPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Password is required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: provider.signupConfirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value != provider.signupPasswordController.text
                          ? 'Passwords don\'t match'
                          : null,
                ),
                const SizedBox(height: 20),
                Consumer<ProductProvider>(
                  builder: (context, prov, child) {
                    return ElevatedButton(
                      onPressed: prov.isSignUp
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final email =
                                    provider.signupEmailController.text;
                                await _sendOTP(email);
                                 final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      uniqueId = nanoId;
                      userUniqueId = nanoId;
                      prefs.setString('userUniqueId', userUniqueId);
                      prefs.setBool('isLoggedIn', true);
                      debugPrint('SignUp userUniqueId : $userUniqueId');
                      debugPrint('uuid : $uniqueId');
                                context
                                    .read<ProductProvider>()
                                    .postSignUpData(context, userUniqueId);
                                Navigator.pushNamed(context, 'otp_screen',
                                    arguments: email);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.appColor,
                          minimumSize: const Size(double.infinity, 50)),
                      child: prov.isSignUp
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Sign Up',
                              style: TextStyle(color: Colors.white)),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Log In',
                            style: TextStyle(color: AppColor.appColor))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
