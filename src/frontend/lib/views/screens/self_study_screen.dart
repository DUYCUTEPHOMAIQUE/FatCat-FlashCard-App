import 'package:FatCat/views/screens/review_study_screen.dart';
import 'package:FatCat/views/widgets/primary_button_widget.dart';
import 'package:FatCat/views/widgets/primary_outline_button.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';
import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/viewmodels/self_study_view_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SelfStudyScreen extends StatelessWidget {
  final List<CardModel> cards;
  final String? question_language;
  final String? answer_language;

  SelfStudyScreen(
      {super.key,
      required this.cards,
      this.question_language,
      this.answer_language});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelfStudyViewModel(cards),
      child: Consumer<SelfStudyViewModel>(
        builder: (context, viewModel, child) {
          print("question_language =====");
          print(question_language);
          print(answer_language);
          if (viewModel.isStudyCompleted) {
            return ReviewStudyScreen(
              detailedAnswers: null,
              correctAnswers: viewModel.greenScore,
              incorrectAnswers: viewModel.orangeScore,
            );
          }
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      // Top navigation bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 32,
                                color: AppColors.greyIcon,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Tự học\n${viewModel.progress} / ${viewModel.cards.length}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                size: 32,
                                color: AppColors.greyIcon,
                              ),
                              onPressed: () {
                                _showSettingsBottomSheet(context, viewModel);
                              },
                            ),
                          ],
                        ),
                      ),
                      // Thanh progress
                      LinearProgressIndicator(
                        value: viewModel.progress / viewModel.cards.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.progressBarColor),
                      ),
                      const SizedBox(height: 16),
                      // Score indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Đang học\n${viewModel.orangeScore}',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Biết\n${viewModel.greenScore}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Centered Card Swiper with equal spacing
                  Expanded(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 630,
                          width: 390,
                          child: CardSwiper(
                            controller: viewModel.cardSwiperController,
                            cardsCount: viewModel.cards.length,
                            onSwipe: viewModel.onSwipe,
                            scale: 1,
                            isLoop: false,
                            numberOfCardsDisplayed: 2,
                            backCardOffset: const Offset(0, 0),
                            padding: const EdgeInsets.all(24.0),
                            maxAngle: 10,
                            cardBuilder: (context, index, percentThresholdX,
                                percentThresholdY) {
                              final isSwipingRight = percentThresholdX > 0;
                              final isSwipingLeft = percentThresholdX < 0;

                              final isNotSwiping = percentThresholdX == 0;
                              Color borderColor = Colors.transparent;
                              double borderWidth = 0.0;
                              if (isNotSwiping) {
                                borderColor = Colors.transparent;
                                borderWidth = 0.0;
                              } else {
                                borderColor = (isSwipingRight || isSwipingLeft)
                                    ? (isSwipingRight
                                        ? AppColors.green
                                        : AppColors.orange)
                                    : Colors.transparent;
                                borderWidth = (isSwipingRight || isSwipingLeft)
                                    ? 2.0
                                    : 0.0;
                              }

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: borderColor,
                                    width: borderWidth,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: FlipCard(
                                  speed: 300,
                                  key: viewModel.cardKeys[index],
                                  direction: FlipDirection.HORIZONTAL,
                                  front: GestureDetector(
                                    onTap: () => viewModel.flipCard(index),
                                    child: _buildCardSide(
                                      viewModel.cards[index].question,
                                      viewModel,
                                      question_language,
                                    ),
                                  ),
                                  back: GestureDetector(
                                    onTap: () => viewModel.flipCard(index),
                                    child: _buildCardSide(
                                      viewModel.cards[index].answer,
                                      viewModel,
                                      answer_language,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom navigation - Fixed at bottom
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: viewModel.goToPreviousCard,
                          color: Colors.grey[600],
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            _showConfirmNextToReview(context, viewModel);
                          },
                          color: Colors.grey[600],
                        ),
                      ],
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

  Widget _buildCardSide(
      String content, SelfStudyViewModel viewModel, String? language) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0.1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: AppColors.greyText,
              ),
            ),
          ),
          Positioned(
            bottom: 12.0,
            right: 12.0,
            child: IconButton(
              icon: const Icon(Icons.volume_up),
              iconSize: 32,
              color: AppColors.greyIcon,
              onPressed: () async {
                await FlutterTts().setLanguage(language ?? "en-US");
                await FlutterTts().speak(content);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsBottomSheet(
      BuildContext context, SelfStudyViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Volume Control
              Row(
                children: [
                  const Text('Volume:'),
                  Expanded(
                    child: Slider(
                      value: viewModel.ttsVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(viewModel.ttsVolume * 100).round()}%',
                      onChanged: (double newValue) {
                        viewModel.setVolume(newValue);
                      },
                      onChangeEnd: (double newValue) {
                        FlutterTts().setVolume(newValue);
                      },
                    ),
                  ),
                ],
              ),
              // Shuffle Cards Button
              ElevatedButton(
                onPressed: () {
                  viewModel.shuffleCards();
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: const Text('Shuffle Cards'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmNextToReview(
      BuildContext context, SelfStudyViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bạn sẽ bỏ qua các thẻ còn lại\nvà thống kê kết quả ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                primaryOutlineButton("Đóng", 150, () {
                  Navigator.of(context).pop();
                }),
                primaryButton(
                  "Đồng ý",
                  150,
                  () {
                    Navigator.of(context).pop();
                    context.pushReplacement(AppRoutes.reviewStudy, extra: {
                      'detailedAnswers': null,
                      'correctAnswers': viewModel.greenScore,
                      'incorrectAnswers': viewModel.orangeScore,
                    });
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
