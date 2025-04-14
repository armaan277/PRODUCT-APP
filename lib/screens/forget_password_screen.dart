import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/product_provider/product_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductProvider>();
    final providerWatch = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColor.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter your email id for the verification process.\nWe will send 4 digit code to your email.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: providerRead.forgetEmailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                hintText: 'Email Id',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            if (providerWatch.errorMessageForget != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  providerWatch.errorMessageForget!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: providerWatch.isLoadingForget
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        String email = providerRead.forgetEmailController.text.trim();
                        if (email.isNotEmpty) {
                          providerRead.postForgetData(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter an email')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.appColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}