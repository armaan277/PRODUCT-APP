import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopping_app/constant/constant.dart';

class PasswordUpdateProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final String? email; // Pass email from previous screen

  PasswordUpdateProvider({this.email});

  Future<void> updatePassword(BuildContext context) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'Please fill all fields';
    } else if (newPassword != confirmPassword) {
      _errorMessage = 'Passwords do not match';
    } else if (email == null) {
      _errorMessage = 'Email not provided';
    } else {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.104:3000/update-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'newPassword': newPassword}),
        );

        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 && responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );
          Navigator.pushNamed(context, 'login_sreen'); // Navigate to login
        } else {
          _errorMessage =
              responseData['message'] ?? 'Failed to update password';
        }
      } catch (e) {
        _errorMessage = 'Network error: $e';
        debugPrint('Error in updatePassword: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}

class CreateNewPasswordScreen extends StatelessWidget {
  final String? email; // Receive email from previous screen
  const CreateNewPasswordScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    debugPrint('Receive email from previous screen : $email');

    return ChangeNotifierProvider(
      create: (context) => PasswordUpdateProvider(email: email),
      child: Consumer<PasswordUpdateProvider>(
        builder: (context, provider, child) {
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
                  const Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: provider.newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      hintText: 'New Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon:
                          const Icon(Icons.visibility_off, color: Colors.grey),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: provider.confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      hintText: 'Confirm New Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon:
                          const Icon(Icons.visibility_off, color: Colors.grey),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  if (provider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: provider.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => provider.updatePassword(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.appColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Update Password',
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
        },
      ),
    );
  }
}
