import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/utils/app_text_style.dart';
import 'package:FatCat/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  const LoginScreenContent({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundScreen,
        elevation: 0,
        title: Text("Đăng Nhập", style: AppTextStyles.boldText28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              "Chào mừng bạn trở lại!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Đăng nhập để bắt đầu học tập hiệu quả!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            _buildTextField("Email", Icons.person, viewModel.emailController),
            SizedBox(height: 16),
            _buildTextField(
                "Mật khẩu",
                Icons.lock,
                isPassword: true,
                viewModel.passwordController),
            SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  context.push(AppRoutes.forgotPassword);
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      viewModel.isLoading ? Colors.grey : Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        if (!viewModel.isLoading) {
                          viewModel.setLoading(true);
                          try {
                            if (viewModel.emailController.text.isEmpty ||
                                viewModel.passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Kiểm tra thông tin đăng nhập')),
                              );
                            } else if (await viewModel.login()) {
                              context.go(AppRoutes.home);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Kiểm tra kết nối mạng')),
                              );
                            }
                          } finally {
                            viewModel.setLoading(false);
                          }
                        }
                      },
                child: viewModel.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Đăng nhập'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  context.push(AppRoutes.signup);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Chưa có tài khoản? ",
                        style: TextStyle(
                          color:
                              Colors.black, // Default color for the first part
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "Đăng ký ngay!",
                        style: TextStyle(
                          color: AppColors
                              .green, // Custom color for "Đăng ký ngay!"
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.blackText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.blackText),
        ),
      ),
    );
  }
}
