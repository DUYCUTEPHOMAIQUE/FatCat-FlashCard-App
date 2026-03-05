import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/models/card_provider.dart';
import 'package:FatCat/models/deck_model.dart';
import 'package:FatCat/viewmodels/card_screen_viewmodel.dart';
import 'package:FatCat/views/screens/create_or_update_deck_screen.dart';
import 'package:FatCat/views/screens/intermittent_study_screen.dart';
import 'package:FatCat/views/screens/multiplechoice_study_screen.dart';
import 'package:FatCat/views/screens/self_study_screen.dart';
import 'package:FatCat/views/widgets/action_bottom_sheet_widget.dart';
import 'package:FatCat/views/widgets/action_button_widget.dart';
import 'package:FatCat/views/widgets/card_item_widget.dart';
import 'package:FatCat/views/widgets/confirm_bottomsheet_widget.dart';
import 'package:FatCat/views/widgets/text_and_showall_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CardsScreen extends StatelessWidget {
  final DeckModel deck;

  final bool? isLocal;
  final VoidCallback? onDelete;
  final bool inClass;
  final String? role;
  final String? classId;
  const CardsScreen(
      {super.key,
      required this.deck,
      this.inClass = false,
      this.isLocal,
      this.onDelete,
      this.role,
      this.classId});

  @override
  Widget build(BuildContext context) {
    print('user_id of deck==${deck.user_id}');
    return ChangeNotifierProvider(
      create: (_) => CardScreenViewModel(
        deck,
        isLocal: isLocal ?? false,
      ),
      child: Consumer<CardScreenViewModel>(
        builder: (context, viewModel, child) {
          List<CardModel> cardData = viewModel.cards;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  context.pop();
                },
              ),
              title: const Text("Thẻ học",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert,
                        size: 28, color: Colors.black),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (context) => ActionBottomSheet(
                          actions: [
                            if (inClass &&
                                (role == 'host' || role == 'manager')) ...[
                              ActionItem(
                                icon: CupertinoIcons.pencil_circle,
                                title: 'Cập nhật bộ thẻ',
                                isDestructive: false,
                                onTap: () async {
                                  context.push(AppRoutes.createDeck, extra: {
                                    'deckId': deck.id,
                                    'userId': deck.user_id,
                                    'initialDeck': deck,
                                    'inClass': true,
                                    'classId': classId,
                                    'initialCards': cardData,
                                    'onDelete': () async {
                                      await viewModel.loadCards();
                                    },
                                  });
                                },
                              ),
                            ],
                            if (isLocal == false) ...[
                              ActionItem(
                                icon: CupertinoIcons.share,
                                title: 'Sao chép bộ thẻ',
                                isDestructive: false,
                                onTap: () async {
                                  if (await viewModel.cloneDecks()) {
                                    await Fluttertoast.showToast(
                                      msg: 'Sao chép thành công',
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0,
                                    );
                                  }
                                },
                              ),
                            ],
                            if (inClass &&
                                (role == 'host' || role == 'manager'))
                              ActionItem(
                                icon: CupertinoIcons.delete,
                                title: 'Xoá bộ thẻ',
                                isDestructive: true,
                                onTap: () async {
                                  bool? rs = await showConfirmBottomSheet(
                                      context,
                                      "Bạn chắc chắn sẽ xoá nó chứ T.T");
                                  if (rs != null) {
                                    if (rs) {
                                      await viewModel.deleteInServer(deck.id!);
                                      // context.pop();
                                    } else {}
                                  }
                                },
                              ),
                            if (isLocal == true) ...[
                              ActionItem(
                                icon: CupertinoIcons.square_pencil,
                                title: 'Chỉnh sửa',
                                onTap: () {
                                  context.push(AppRoutes.createDeck, extra: {
                                    'deckId': deck.id,
                                    'initialDeck': deck,
                                    'initialCards': cardData,
                                    'onDelete': () async {
                                      await viewModel.loadCards();
                                      await viewModel.loadDeck();
                                    },
                                  });
                                },
                              ),
                              ActionItem(
                                icon: Icons.share,
                                title: 'Chia sẻ với mọi người',
                                isDestructive: false,
                                onTap: () async {
                                  Fluttertoast.showToast(
                                    msg: 'Chia sẻ thành công',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0,
                                  );
                                },
                              ),
                              ActionItem(
                                icon: CupertinoIcons.delete,
                                title: 'Xóa',
                                isDestructive: true,
                                onTap: () async {
                                  showConfirmBottomSheet(
                                    context,
                                    'Bạn chắc chắn muốn xoá bộ thẻ này không',
                                    onConfirm: () async {
                                      await viewModel
                                          .deleteAllCardsForDeck(deck.id!);
                                      Fluttertoast.showToast(
                                        msg: "Xóa thành công",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0,
                                      );
                                      if (onDelete != null) {
                                        onDelete!();
                                      }
                                    },
                                  );

                                  // context.pop();
                                },
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tác giả: ${viewModel.deck.user_name ?? 'Bạn'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${viewModel.deck.deck_cards_count} Thuật ngữ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(deck.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 20),
                    const Text(
                      'Chọn chế độ học',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    actionButtonWidget(
                        pathName: 'mode_red.png',
                        text: "Tự học",
                        onTap: () {
                          if (!cardData.isEmpty) {
                            context.push(AppRoutes.selfStudy, extra: {
                              'cards': cardData,
                              'question_language': deck.question_language,
                              'answer_language': deck.answer_language,
                            });
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    actionButtonWidget(
                        pathName: 'mode_blue.png',
                        text: "Học theo tiến trình",
                        onTap: () {
                          if (!cardData.isEmpty) {
                            context.push(AppRoutes.intermittentStudy, extra: {
                              'cards': cardData,
                              'question_language': deck.question_language,
                              'answer_language': deck.answer_language,
                            });
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    actionButtonWidget(
                        pathName: 'mode_green.png',
                        text: "Học chọn nhiều đáp án",
                        onTap: () {
                          if (!cardData.isEmpty) {
                            context.push(AppRoutes.multipleChoice, extra: {
                              'cards': cardData,
                            });
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Tất cả thuật ngữ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    if (!viewModel.isLoading)
                      Container(
                        height: 250,
                        child: PageView.builder(
                          itemCount: viewModel.cards.length,
                          onPageChanged: (index) {
                            viewModel.currentIndex = index;
                          },
                          itemBuilder: (context, index) {
                            return CardItemWidget(
                              question: viewModel.cards[index].question,
                              answer: viewModel.cards[index].answer,
                              question_language: deck.question_language,
                              answer_language: deck.answer_language,
                            );
                          },
                        ),
                      ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        viewModel.cards.length > 5 ? 5 : viewModel.cards.length,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: viewModel.currentIndex == index ? 8.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: viewModel.currentIndex == index
                                  ? Colors.grey
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
