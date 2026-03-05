import 'package:FatCat/router/app_router.dart';
import 'package:FatCat/services/user_local_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class SettingViewModel extends ChangeNotifier {
  bool _notificationEnabled = true;
  bool _darkModeEnabled = false;
  bool _isLoggedIn = false;
  Map<String, dynamic> userInfo = {};

  bool get isLoggedIn => _isLoggedIn;
  bool get notificationEnabled => _notificationEnabled;

  SettingViewModel() {
    checkLoginStatus();
  }

  void updateUserInfo(Map<String, String> newUserInfo) {
    userInfo = newUserInfo;
    print('OKKK OTP');
    notifyListeners();
  }

  void logout() {
    UserLocalService.logout();
    userInfo = {};
    _isLoggedIn = false;
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  void routeToForgotPass(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  void routeToChangePass(BuildContext context) {
    context.push(AppRoutes.changePassword);
  }

  Future<void> checkLoginStatus() async {
    final fetchUserInfo = await UserLocalService.getUserInfo();
    _isLoggedIn = fetchUserInfo['name']?.isNotEmpty == true;
    userInfo.addAll(fetchUserInfo);
    print('User info: ${userInfo['email']} -- islogin$isLoggedIn');
    notifyListeners();
  }

  void routeToLogin(BuildContext context) {
    context.push(AppRoutes.login);
  }
}
