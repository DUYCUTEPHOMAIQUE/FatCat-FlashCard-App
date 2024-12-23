import 'package:FatCat/services/auth_service.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpViewModel extends ChangeNotifier {
  // final storage = FlutterSecureStorage();
  final AuthService authService = AuthService();
  final String _errorMessage = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  Future<bool> verifyOTP(
      String otp, String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    if (await authService.verifyOTP(email, password, name, otp)) {
      _isLoading = true;
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resendOTP(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      await AuthService.resendOTP(email);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = true;
      notifyListeners();
    }
  }
}
