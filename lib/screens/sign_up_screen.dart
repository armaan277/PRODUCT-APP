import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/config/endpoints.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class SignUpScreen extends StatefulWidget {
  final String? name;
  final String? email;

  const SignUpScreen({super.key, this.name, this.email});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nanoId = nanoid(8);
  late final uniqueId;
  
  final _formKey = GlobalKey<FormState>();
  String error = '';

  Future<void> _sendOTP(String email, ProductProvider provider) async {
    if (widget.email == null) { // Only for normal sign-up
      provider.setIsSignUp(true);
      final response = await http.post(
        Uri.parse(EndPoints.sendOTPEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      debugPrint('_sendOTP :- ${response.body}');

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      debugPrint('responseBody : $responseBody');
      if (response.statusCode == 200) {
        Navigator.pushNamed(
          context,
          'otp_screen',
          arguments: email,
        );
      } else if (response.statusCode == 409) {
        error = responseBody['message'] ?? 'Error occurred';
      } else {
        error = 'Failed to send OTP';
      }
      provider.setIsSignUp(false);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerRead = context.read<ProductProvider>();
      if (widget.name != null) providerRead.signupNameController.text = widget.name!;
      if (widget.email != null) providerRead.signupEmailController.text = widget.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    final isGoogleSignUp = widget.email != null && widget.name != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Complete your details to register and start exploring.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: providerRead.signupNameController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    value = value.trim();
                    if (value.length > 50) {
                      return 'Name cannot exceed 50 characters';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name can only contain letters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.appColor),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: providerRead.signupPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone is required';
                    }
                    value = value.trim();
                    if (value.length != 10) {
                      return 'Phone must be exactly 10 digits';
                    }
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                      return 'Enter valid Indian number (starts with 6-9)';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.appColor),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Phone',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: providerRead.signupEmailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  enabled: !isGoogleSignUp,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    value = value.trim();
                    if (value.length > 100) {
                      return 'Email cannot exceed 100 characters';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      error = '';
                      setState(() {});
                      return 'Enter a valid email address (e.g., user@gmail.com)';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.appColor),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
                if (error.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: providerRead.signupPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    value = value.trim();
                    if (value.length > 50) {
                      return 'Password cannot exceed 50 characters';
                    }
                    if (value.contains(' ')) {
                      return 'Password cannot contain spaces';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.appColor),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: providerRead.signupConfirmPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Confirm Password is required';
                    }
                    value = value.trim();
                    if (value.length > 50) {
                      return 'Confirm Password cannot exceed 50 characters';
                    }
                    if (value != providerRead.signupPasswordController.text.trim()) {
                      return 'Passwords do not match';
                    }
                    if (value.contains(' ')) {
                      return 'Confirm Password cannot contain spaces';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.appColor),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Confirm Password',
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<ProductProvider>(
                  builder: (context, prov, child) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: prov.isSignUp
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    if (isGoogleSignUp) {
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      uniqueId = nanoId;
                                      userUniqueId = nanoId;
                                      prefs.setString('userUniqueId', userUniqueId);
                                      prefs.setBool('isLoggedIn', true);
                                      debugPrint('SignUp userUniqueId : $userUniqueId');
                                      debugPrint('uuid : $uniqueId');
                                      await prov.googleSignUp(context, userUniqueId); // Google signup
                                    } else {
                                      final email =
                                          providerRead.signupEmailController.text.trim();
                                      await _sendOTP(email, prov); // Normal signup with OTP
                                    }
                                  }
                                },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.appColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: prov.isSignUp
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login_sreen');
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
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