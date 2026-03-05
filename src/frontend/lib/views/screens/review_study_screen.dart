import 'package:FatCat/viewmodels/review_screen_view_model.dart';
import 'package:FatCat/viewmodels/screen_control_viewmodel.dart';
import 'package:FatCat/views/screens/decks_control_screen.dart';
import 'package:FatCat/views/widgets/primary_button_widget.dart';
import 'package:FatCat/views/widgets/primary_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReviewStudyScreen extends StatelessWidget {
  final int? correctAnswers;
  final int? incorrectAnswers;
  final Map<String, int>? detailedAnswers;

  ReviewStudyScreen({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.detailedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewScreenViewModel(),
      child:
          Consumer<ReviewScreenViewModel>(builder: (context, viewModel, child) {
        String text = "Thống kê tiến độ học tập của bạn";
        if (incorrectAnswers != null && correctAnswers != null) {
          text = viewModel.generateTextReviewSelfStudy(
              incorrectAnswers!, correctAnswers!);
        } else if (detailedAnswers != null) {
          text =
              viewModel.generateTextReviewIntermittentStudy(detailedAnswers!);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: const Text(
              'Tiến độ của bạn',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Main content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Checkmark icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.green, width: 4),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.green,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Congratulatory text
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Progress indicators
                      if (detailedAnswers != null) ...[
                        _buildProgressIndicator(
                            'Dễ', detailedAnswers!['Dễ'] ?? 0, Colors.green),
                        const SizedBox(height: 8),
                        _buildProgressIndicator(
                            'Tốt', detailedAnswers!['Tốt'] ?? 0, Colors.blue),
                        const SizedBox(height: 8),
                        _buildProgressIndicator(
                            'Khó', detailedAnswers!['Khó'] ?? 0, Colors.orange),
                        const SizedBox(height: 8),
                        _buildProgressIndicator('Học lại',
                            detailedAnswers!['Học lại'] ?? 0, Colors.red),
                      ] else ...[
                        _buildProgressIndicator(
                            'Biết', correctAnswers ?? 0, Colors.green),
                        const SizedBox(height: 8),
                        _buildProgressIndicator(
                            'Đang học', incorrectAnswers ?? 0, Colors.orange),
                        const SizedBox(height: 8),
                        _buildProgressIndicator('Còn lại', 0, Colors.grey),
                      ],
                    ],
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      primaryButton(
                        'Ôn luyện lại trong chế độ học',
                        double.infinity,
                        () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 8),
                      primaryOutlineButton(
                          'Đặt lại thẻ ghi nhớ', double.infinity, () {
                        Navigator.pop(context);
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProgressIndicator(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
