import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/services/auth_service.dart';
import 'package:FatCat/views/widgets/confirm_bottomsheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePassWordScreen extends StatelessWidget {
  const ChangePassWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 338,
                height: 40,
                child: Text(
                  'Thay đổi mật khẩu',
                  style: TextStyle(
                    color: Color(0xFF010F07),
                    fontSize: 33,
                    fontFamily: 'Yu Gothic UI',
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.22,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: 274,
                height: 50,
                child: Text(
                  'Nhập mật khẩu hiện tại và mật khẩu mới của bạn.',
                  style: TextStyle(
                    color: Color(0xFF868686),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.40,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField(
                  "Mật khẩu hiện tại", currentPasswordController, true),
              const SizedBox(height: 16),
              _buildTextField("Mật khẩu mới", newPasswordController, true),
              const SizedBox(height: 16),
              _buildTextField(
                  "Xác nhận mật khẩu mới", confirmPasswordController, true),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundButtonColor,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                  // style: ElevatedButtonStyle.primaryFirst(),
                  onPressed: () async {
                    if (newPasswordController.text ==
                        confirmPasswordController.text) {
                      bool? confirmed = await showConfirmBottomSheet(
                          context, "Bạn có chắc muốn đổi mật khẩu");

                      if (confirmed == true) {
                        bool rs = await AuthService.changePassword(
                            currentPasswordController.text.trim(),
                            confirmPasswordController.text.trim());

                        if (rs) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Đổi mật khẩu thành công')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Đổi mật khẩu thất bại')),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Mật khẩu mới không khớp')),
                      );
                    }
                  },
                  child: const Text('XÁC NHẬN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: label,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.brown,
                width: 4.0,
              ),
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }
}
