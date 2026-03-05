// ignore_for_file: unnecessary_string_interpolations

import 'package:FatCat/constants/colors.dart';
import 'package:FatCat/models/class_model.dart';
import 'package:FatCat/models/deck_model.dart';
import 'package:FatCat/viewmodels/class_detail_viewmodel.dart';
import 'package:FatCat/views/screens/cards_screen.dart';
import 'package:FatCat/views/screens/create_or_update_deck_screen.dart';
import 'package:FatCat/views/widgets/action_bottom_sheet_widget.dart';
import 'package:FatCat/views/widgets/confirm_bottomsheet_widget.dart';
import 'package:FatCat/views/widgets/deck_lib_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel mClass;
  final String? role;
  final VoidCallback? onDelete;
  final String? inviteCode;
  final bool inClass;
  const ClassDetailScreen(
      {super.key,
      required this.mClass,
      this.onDelete,
      this.role,
      this.inviteCode,
      this.inClass = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClassDetailViewmodel(mClass: mClass),
      child: Consumer<ClassDetailViewmodel>(
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("${mClass.name}"),
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
                              if (role == null)
                                ActionItem(
                                  icon: Icons.login,
                                  title: 'Tham gia nhóm',
                                  onTap: () {
                                    if (inviteCode != null) {
                                      viewModel.joinClass(inviteCode!);
                                    }
                                  },
                                ),
                              if (role != null &&
                                  (role == 'host' || role == 'manager') &&
                                  inClass)
                                ActionItem(
                                  icon: CupertinoIcons.add,
                                  title: 'Tạo bộ thẻ',
                                  onTap: () {
                                    context.push(AppRoutes.createDeck, extra: {
                                      'classId': mClass.id,
                                      'inClass': true,
                                    });
                                  },
                                ),
                              ActionItem(
                                icon: Icons.share,
                                title: 'Chia sẻ mã nhóm',
                                isDestructive: false,
                                onTap: () async {
                                  if (inviteCode != null) {
                                    await Clipboard.setData(
                                        ClipboardData(text: inviteCode!));
                                    Fluttertoast.showToast(
                                      msg: "Đã sao chép mã nhóm",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0,
                                    );
                                  }
                                },
                              ),
                              if (role != null && role != 'host')
                                ActionItem(
                                  icon: Icons.logout,
                                  title: 'Rời nhóm',
                                  isDestructive: true,
                                  onTap: () async {
                                    showConfirmBottomSheet(
                                        context, 'Bạn sẽ rời khỏi nhóm này',
                                        onConfirm: () async {
                                      await viewModel.leaveClass();
                                      if (onDelete != null) {
                                        print('===onDelete');
                                        onDelete!();
                                      }
                                      // Navigator.pop(context);
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                bottom: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackText,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                  ),
                  indicatorColor: AppColors.green,
                  labelColor: AppColors.green,
                  tabs: [
                    Tab(
                      text: "Bộ thẻ",
                    ),
                    Tab(text: "Thành viên"),
                    Tab(text: 'Xếp hạng')
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  DecksTab(
                    mClass: mClass,
                    viewmodel: viewModel,
                    role: role,
                  ), // Tab 1: Decks
                  MembersTab(viewmodel: viewModel), // Tab 2: Members
                  MembersRankingTab(), // Tab 3: Members Ranking
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DecksTab extends StatelessWidget {
  final ClassModel mClass;
  final ClassDetailViewmodel viewmodel;
  final String? role;
  final bool inClass;
  const DecksTab(
      {super.key,
      required this.mClass,
      required this.viewmodel,
      this.role,
      this.inClass = true});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await viewmodel.fetchDecks();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: viewmodel.decks.length,
          itemBuilder: (context, index) {
            final deck = viewmodel.decks[index];
            return DeckLibWidget(
              deck: deck,
              color: AppColors.green,
              onTap: () async {
                context.push(AppRoutes.cards, extra: {
                  'deck': deck,
                  'isLocal': false,
                  'inClass': inClass,
                  'role': role,
                  'classId': mClass.id,
                  'onDelete': () async {
                    await viewmodel.fetchDecks();
                  },
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class MembersTab extends StatelessWidget {
  final ClassDetailViewmodel viewmodel;
  const MembersTab({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: viewmodel.classMembers.length,
        itemBuilder: (context, index) {
          final user = viewmodel.classMembers[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.green,
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Tham gia: ${user.joinedAt?.substring(0, 10)}\tRole: ${user.role}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MembersRankingTab extends StatelessWidget {
  const MembersRankingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Members content goes here"),
    );
  }
}
