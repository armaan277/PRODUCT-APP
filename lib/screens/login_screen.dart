import 'package:flutter/material.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/widgets/bottom_navigation_bar.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isRemember = false;
  bool isPasswordShow = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  obscureText: isPasswordShow == true ? isPasswordShow : false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffixIcon: isPasswordShow == true
                        ? IconButton(
                            onPressed: () {
                              isPasswordShow = false;
                              setState(() {});
                            },
                            icon: const Icon(Icons.visibility),
                            color: Colors.grey,
                          )
                        : IconButton(
                            onPressed: () {
                              isPasswordShow = true;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.visibility_off,
                            ),
                          ),
                    border: const OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.appColor,
                          value: isRemember,
                          onChanged: (value) {
                            isRemember = value!;
                            setState(() {});
                          },
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forget Password',
                        style: TextStyle(
                          color: AppColor.appColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const BottomNavigation();
                    }));
                  },
                  child: GestureDetector(
                    onTap: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const BottomNavigation();
                        }));
                        
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.appColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
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
                ),
                const SizedBox(height: 25),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/google_icon.png',
                      height: 60,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/facebook_icon.png',
                      height: 44,
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/twitter_icon.png',
                      height: 36,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account"),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
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
        ),
      ),
    );
  }
}
