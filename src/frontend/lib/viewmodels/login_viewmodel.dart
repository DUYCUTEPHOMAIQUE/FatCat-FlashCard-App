import 'package:FatCat/router/app_router.dart';
import 'package:FatCat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

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
    context.push(AppRoutes.signup);
  }

  void routeToForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
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
