import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/constant/constant.dart';
import 'package:shopping_app/screens/create_new_password_screen.dart';

class OTPScreen extends StatefulWidget {
  final String? email;
  const OTPScreen({super.key, this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
    setState(() => _isLoading = true); // Start loading
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.0.104:3000/validate-otp'), // Replace with your PC's IP
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      debugPrint('response.statusCode OTPScreen : ${response.statusCode}');
      debugPrint('response.body OTPScreen : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('data');
        if (data['success']) {
          debugPrint('OTP validated, navigating to /bottom_navigation');
          Navigator.pushReplacementNamed(context, 'bottom_navigation');
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data['message'])));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Validation failed')));
      }
    } catch (e) {
      debugPrint('Validation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error, try again')));
    } finally {
      setState(() => _isLoading = false); // Always stop loading
    }
  }

  Future<void> _resendOTP(String email) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.0.104:3000/send-otp'), // Replace with your PC's IP
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('OTP resent')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Resend failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? email =
        widget.email ?? ModalRoute.of(context)?.settings.arguments as String?;

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
                            borderRadius: BorderRadius.circular(10)),
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
              onPressed: email == null ? null : () => _resendOTP(email),
              child: const Text('Resend OTP',
                  style: TextStyle(color: AppColor.appColor)),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final otp = _controllers.map((c) => c.text).join();
                      if (otp.length == 4 && email != null) {
                        _validateOTP(email, otp);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 4-digit OTP')));
                      }
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return CreateNewPasswordScreen();
                      //     },
                      //   ),
                      // );
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
