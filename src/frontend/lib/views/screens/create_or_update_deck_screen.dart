import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/models/deck_model.dart';
import 'package:flutter/material.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:FatCat/viewmodels/create_deck_viewmodel.dart';
import 'package:FatCat/views/widgets/card_edit_widget.dart';

class CreateOrUpdateDeckScreen extends StatelessWidget {
  final String? deckId;
  final DeckModel? initialDeck;
  final List<CardModel>? initialCards;
  final VoidCallback? onDelete;
  final bool inClass;
  final String? classId;
  final String? userId;
  const CreateOrUpdateDeckScreen(
      {Key? key,
      this.deckId,
      this.initialDeck,
      this.initialCards,
      this.onDelete,
      this.classId,
      this.userId,
      this.inClass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateOrUpdateDeckViewModel(
        deckId: deckId,
        userId: userId,
        initialDeck: initialDeck,
        initialCards: initialCards,
      ),
      child: Consumer<CreateOrUpdateDeckViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.backgroundScreen,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                deckId == null ? 'Tạo bộ thẻ mới' : 'Chỉnh sửa bộ thẻ',
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.check, size: 32),
                    onPressed: () async {
                      if (inClass && classId != null) {
                        print('=====Inclass');
                        await viewModel.saveDeckToServer(classId!);
                        context.pop();
                      } else {
                        print('=====khong trong class');

                        await viewModel.saveDeck();
                        if (onDelete != null) {
                          onDelete!();
                        }
                        context.go(AppRoutes.decks);
                      }
                    },
                  ),
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Title input section
                      Text(
                        'Tiêu đề',
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: viewModel.titleController,
                        decoration: InputDecoration(
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
                      ),
                      const SizedBox(height: 16),
                      // Description input section
                      Text(
                        'Mô tả',
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: viewModel.descriptionController,
                        decoration: InputDecoration(
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
                      ),
                      const SizedBox(height: 16),
                      // Front language dropdown
                      Text(
                        'Ngôn ngữ thuật ngữ',
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: viewModel.selectedFrontLanguage,
                        decoration: InputDecoration(
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
                        items: [
                          'Tiếng Việt',
                          'English',
                          'Japanese',
                          'Tiếng Trung'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          viewModel.setFrontLanguage(newValue!);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Back language dropdown
                      Text(
                        'Ngôn ngữ định nghĩa',
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: viewModel.selectedBackLanguage,
                        decoration: InputDecoration(
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
                        items: [
                          'Tiếng Việt',
                          'English',
                          'Japanese',
                          'Tiếng Trung'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          viewModel.setBackLanguage(newValue!);
                        },
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
                // Cards section
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: CardEditWidget(
                          key: ValueKey(index),
                          card: viewModel.cards[index],
                          onRemove: () => viewModel.removeCard(index),
                          onCardChanged: (updatedCard) =>
                              viewModel.updateCard(index, updatedCard),
                        ),
                      );
                    },
                    childCount: viewModel.cards.length,
                  ),
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                backgroundColor: Colors.brown,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () => viewModel.addCard(),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }
}
