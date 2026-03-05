import 'package:FatCat/views/screens/cards_screen.dart';
import 'package:FatCat/views/widgets/deck_lib_widget.dart';
import 'package:flutter/material.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/library_viewmodel.dart';
import 'not_connection_screen.dart';
import '../../utils/app_text_style.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryViewModel(),
      child: Consumer<LibraryViewModel>(
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: 6,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Library", style: AppTextStyles.boldText28),
                bottom: const TabBar(
                  isScrollable: true,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple,
                  ),
                  indicatorColor: Colors.purple,
                  tabs: [
                    Tab(text: 'Tất cả'),
                    Tab(text: 'Ngôn ngữ'),
                    Tab(text: 'Toán học'),
                    Tab(text: 'Khoa học'),
                    Tab(text: 'Nghệ thuật'),
                    Tab(text: 'Văn học'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildDeckList(viewModel),
                  _buildDeckList(viewModel, category: 'Ngôn ngữ'),
                  _buildDeckList(viewModel, category: 'Toán học'),
                  _buildDeckList(viewModel, category: 'Khoa học'),
                  _buildDeckList(viewModel, category: 'Nghệ thuật'),
                  _buildDeckList(viewModel, category: 'Văn học'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeckList(LibraryViewModel viewModel, {String? category}) {
    final filteredDecks = category == null
        ? viewModel.decks
        : viewModel.decks
            .where((deck) => deck.category_name == category)
            .toList();

    if (viewModel.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.purple));
    }

    return RefreshIndicator(
      color: Colors.purple,
      onRefresh: viewModel.fetchDecks,
      child: viewModel.error != null
          ? ListView(
              children: [
                Container(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          'Không có bộ bài nào\nKéo xuống để tải lại',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemCount: filteredDecks.length,
              itemBuilder: (context, index) {
                final deck = filteredDecks[index];
                return DeckLibWidget(
                  deck: deck,
                  onTap: () async {
                    context.push(AppRoutes.cards, extra: {
                      'deck': deck,
                      'isLocal': false,
                    });
                  },
                );
              },
            ),
    );
  }
}
