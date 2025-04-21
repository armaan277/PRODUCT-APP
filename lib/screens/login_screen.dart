import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';
import 'package:shopping_app/screens/sign_up_screen.dart';

import 'forget_password_screen.dart';

class LogInScreen extends StatefulWidget {
  final String? email;
  const LogInScreen({super.key, this.email});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isRemember = false;
  bool isPasswordShow = true;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerRead = context.read<ProductProvider>();
      providerRead.emailController.clear();
      providerRead.passwordController.clear();
      // Pre-fill email if passed via constructor
      debugPrint('LogInScreen widget.email : ${widget.email}');

      if (widget.email != null) {
        providerRead.emailController.text = widget.email!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    final providerWatch = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: providerWatch.isLogin ? 0.2 : 1,
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: AppColor.appColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        textAlign: TextAlign.center,
                        'Sign in with your email and password or \n continue with our app.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: providerRead.emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
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
                            return 'Enter a valid email address';
                          }
                          if (value.contains(' ')) {
                            return 'Email cannot contain spaces';
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: providerRead.passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        obscureText: isPasswordShow,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.appColor),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordShow = !isPasswordShow;
                              });
                            },
                            icon: Icon(
                              isPasswordShow
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            color: Colors.grey,
                          ),
                          border: const OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                      if (providerWatch.errorMessageLogIn != null) ...[
                        SizedBox(height: 5),
                        Text(
                          providerWatch.errorMessageLogIn!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: AppColor.appColor,
                                value: isRemember,
                                onChanged: (value) {
                                  setState(() {
                                    isRemember = value!;
                                  });
                                },
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ForgotPasswordScreen(
                                  email: providerRead.emailController.text
                                          .trim()
                                          .isNotEmpty
                                      ? providerRead.emailController.text.trim()
                                      : null,
                                );
                              }));
                            },
                            child: const Text(
                              'Forget Password',
                              style: TextStyle(
                                color: AppColor.appColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState?.validate() ?? false) {
                            providerRead.postLoginData(context);
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
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Divider(
                              thickness: 1.5,
                              color: Colors.grey.shade200,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Divider(
                              thickness: 1.5,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          providerRead.signInWithGoogle(context);
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.appColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  'assets/google_icon.png',
                                  height: 34,
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Login with Google',
                                  style: TextStyle(
                                    color: AppColor.appColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account"),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColor.appColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (providerWatch.isLogin)
                  const CircularProgressIndicator(
                    color: Colors.red,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
