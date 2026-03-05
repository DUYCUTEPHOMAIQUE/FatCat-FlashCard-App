import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/utils/app_text_style.dart';
import 'package:FatCat/viewmodels/deck_control_viewmodel.dart';
import 'package:FatCat/views/screens/cards_screen.dart';
import 'package:FatCat/views/screens/create_or_update_deck_screen.dart';
import 'package:FatCat/views/widgets/deck_lib_widget.dart';
import 'package:flutter/material.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DecksControl extends StatelessWidget {
  const DecksControl({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DecksControlViewModel()..fetchData(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.backgroundScreen,
          appBar: AppBar(
            title: Text("Decks", style: AppTextStyles.boldText28),
            backgroundColor: AppColors.backgroundScreen,
            bottom: const TabBar(
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.brown,
              ),
              indicatorColor: Colors.brown,
              tabs: [
                Tab(text: 'Bộ thẻ của bạn'),
                Tab(text: 'Bộ thẻ đã tải'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildYourDecks(),
              _buildDownloadedDecks(),
            ],
          ),
          floatingActionButton: Consumer<DecksControlViewModel>(
            builder: (context, viewModel, child) =>
                FloatingActionButton.extended(
              onPressed: () {
                context.push(AppRoutes.createDeck, extra: {
                  'onDelete': () async {
                    await viewModel.fetchDecks();
                  },
                });
              },
              backgroundColor: Colors.brown,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tạo bộ thẻ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYourDecks() {
    return Consumer<DecksControlViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.error != null) {
          return RefreshIndicator(
              color: Colors.brown,
              onRefresh: () async {
                await viewModel.fetchDecks();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                          'Không có bộ thẻ nào.\nError: ${viewModel.error}'),
                    ),
                  ),
                ],
              ));
        } else if (viewModel.decks.isEmpty) {
          return RefreshIndicator(
              color: Colors.brown,
              onRefresh: () async {
                await viewModel.fetchDecks();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: Text('Không có bộ thẻ nào.'),
                    ),
                  ),
                ],
              ));
        } else {
          return RefreshIndicator(
            color: Colors.brown,
            onRefresh: () async {
              await viewModel.fetchDecks();
            },
            child: ListView.builder(
              itemCount: viewModel.decks.length,
              itemBuilder: (context, index) {
                final deck = viewModel.decks[index];
                return DeckLibWidget(
                  color: Colors.brown,
                  deck: deck,
                  onTap: () async {
                    context.push(AppRoutes.cards, extra: {
                      'deck': deck,
                      'isLocal': true,
                      'onDelete': () {
                        viewModel.fetchData();
                      },
                    });
                  },
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildDownloadedDecks() {
    return Consumer<DecksControlViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.error != null) {
          return RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchDecksDownloaded();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                          'Không có bộ thẻ nào.\nError: ${viewModel.error}'),
                    ),
                  ),
                ],
              ));
        } else if (viewModel.decks.isEmpty) {
          return RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchDecksDownloaded();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: Text('Không có bộ thẻ nào.'),
                    ),
                  ),
                ],
              ));
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await viewModel.fetchDecksDownloaded();
            },
            child: ListView.builder(
              itemCount: viewModel.decksDownloaded.length,
              itemBuilder: (context, index) {
                final deck = viewModel.decksDownloaded[index];
                return DeckLibWidget(
                  color: Colors.brown,
                  deck: deck,
                  onTap: () async {
                    context.push(AppRoutes.cards, extra: {
                      'deck': deck,
                      'isLocal': true,
                      'onDelete': () async {
                        await viewModel.fetchData();
                      },
                    });
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
