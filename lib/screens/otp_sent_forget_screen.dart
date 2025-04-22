import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/config/endpoints.dart';
import 'dart:convert';
import 'package:shopping_app/constant/constant.dart';

class OTPSentForgetScreen extends StatefulWidget {
  final String? email;
  const OTPSentForgetScreen({super.key, this.email});

  @override
  State<OTPSentForgetScreen> createState() => _OTPSentForgetScreenState();
}

class _OTPSentForgetScreenState extends State<OTPSentForgetScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (i) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (i) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _validateOTP(String email, String otp) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(EndPoints.validateOTPEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP validated!')),
          );
          // Navigate to CreateNewPasswordScreen using pushReplacementNamed with email
          Navigator.pushReplacementNamed(
            context,
            'create_new_password_screen',
            arguments: email, // Pass email as argument
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Invalid OTP')),
          );
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Validation failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Network error')));
      debugPrint('Validation error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? email =
        widget.email ?? ModalRoute.of(context)?.settings.arguments as String?;
    debugPrint('Received Email in OTPScreen: $email');

    String otp = _controllers.map((c) => c.text.trim()).join();
    debugPrint('Email: $email, OTP: $otp, Length: ${otp.length}');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (email != null)
              Text('OTP for: $email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Enter your 4-digit OTP',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && i < 3)
                          FocusScope.of(context).nextFocus();
                        if (value.isEmpty && i > 0)
                          FocusScope.of(context).previousFocus();
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: email == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP resent')));
                    },
              child: const Text('Resend OTP',
                  style: TextStyle(color: AppColor.appColor)),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final otp = _controllers.map((c) => c.text.trim()).join();
                      if (otp.length == 4 && email != null) {
                        debugPrint('If condition met: OTP=$otp, Email=$email');
                        _validateOTP(email, otp);
                      } else {
                        debugPrint(
                            'Else condition: OTP=$otp, Length=${otp.length}, Email=$email');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter 4-digit OTP'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.appColor,
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Verify',
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}
