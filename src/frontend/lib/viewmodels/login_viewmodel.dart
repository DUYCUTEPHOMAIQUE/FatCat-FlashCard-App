import 'package:FatCat/services/auth_service.dart';
import 'package:FatCat/views/screens/forgot_password_screen.dart';
import 'package:FatCat/views/screens/signup_screen.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  final AuthService authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void routeToSignUp(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void routeToForgotPassword(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ForgotPassword()));
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    if (await authService.login(
        emailController.text, passwordController.text)) {
      setLoading(false);
      return true;
    } else {
      _errorMessage = 'Login failed. Please try again.';
      setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
