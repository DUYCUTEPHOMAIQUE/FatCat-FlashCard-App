import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/viewmodels/otp_viewmodel.dart';
import 'package:FatCat/viewmodels/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  final Map<String, String> data;
  const OtpScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(),
      child: VerifyOTPScreenView(data: data),
    );
  }
}

class VerifyOTPScreenView extends StatelessWidget {
  final Map<String, String> data;
  VerifyOTPScreenView({super.key, required this.data});
  //viewmodel
  final OtpViewModel viewModel = OtpViewModel();
  final settingViewModel = SettingViewModel();
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    String name = data['name']!;
    String email = data['email']!;
    String password = data['password']!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Xác nhận OTP code đã gửi tới',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 52,
                  height: 52,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundButtonColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                if (await viewModel.verifyOTP(
                  _controllers.map((controller) => controller.text).join(),
                  email,
                  password,
                  name,
                )) {
                  await settingViewModel.checkLoginStatus();
                  context.go(AppRoutes.home);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(viewModel.errorMessage),
                    ),
                  );
                }
              },
              child: Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // TODO: Implement resend OTP logic
                print('Resending OTP');
                viewModel.resendOTP(email);
              },
              child: const Text('Resend OTP',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
