import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/models/class_model.dart';
import 'package:FatCat/models/deck_model.dart';
import 'package:FatCat/views/screens/OTP_screen.dart';
import 'package:FatCat/views/screens/cards_screen.dart';
import 'package:FatCat/views/screens/category_screen.dart';
import 'package:FatCat/views/screens/change_password_screen.dart';
import 'package:FatCat/views/screens/class_detail_screen.dart';
import 'package:FatCat/views/screens/class_screen.dart';
import 'package:FatCat/views/screens/create_or_update_deck_screen.dart';
import 'package:FatCat/views/screens/decks_control_screen.dart';
import 'package:FatCat/views/screens/forgot_password_screen.dart';
import 'package:FatCat/views/screens/home_screen.dart';
import 'package:FatCat/views/screens/intermittent_study_screen.dart';
import 'package:FatCat/views/screens/library_screen.dart';
import 'package:FatCat/views/screens/login_screen.dart';
import 'package:FatCat/views/screens/multiplechoice_study_screen.dart';
import 'package:FatCat/views/screens/rank_screen.dart';
import 'package:FatCat/views/screens/self_study_screen.dart';
import 'package:FatCat/views/screens/settings_screen.dart';
import 'package:FatCat/views/screens/signup_screen.dart';
import 'package:FatCat/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Định nghĩa tất cả các route name trong app
class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const otp = '/otp';
  static const forgotPassword = '/forgot-password';
  static const changePassword = '/change-password';

  // Shell tabs
  static const home = '/home';
  static const decks = '/decks';
  static const library = '/library';
  static const classes = '/class';
  static const settings = '/settings';

  // Detail screens (không có bottom nav)
  static const cards = '/cards';
  static const createDeck = '/create-deck';
  static const category = '/category';
  static const rank = '/rank';
  static const selfStudy = '/self-study';
  static const intermittentStudy = '/intermittent-study';
  static const multipleChoice = '/multiple-choice';
  static const classDetail = '/class-detail';
}

/// Bottom navigation bar shell widget dùng với StatefulShellRoute
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  static const List<Color> _activeColors = [
    AppColors.tabHome,
    AppColors.tabDecks,
    AppColors.tabLibrary,
    AppColors.tabClass,
    AppColors.tabSettings,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: _activeColors[currentIndex],
        unselectedItemColor: AppColors.grey,
        backgroundColor: AppColors.white,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_stack),
            label: 'Bộ thẻ',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_favorites),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
            label: 'Lớp học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}

/// GoRouter configuration cho toàn bộ app
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // ── Auth routes ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) => OtpScreen(
        data: state.extra as Map<String, String>,
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) => const ChangePassWordScreen(),
    ),

    // ── Detail routes (không có bottom nav bar) ───────────────
    GoRoute(
      path: AppRoutes.cards,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return CardsScreen(
          deck: args['deck'] as DeckModel,
          isLocal: args['isLocal'] as bool?,
          onDelete: args['onDelete'] as VoidCallback?,
          inClass: args['inClass'] as bool? ?? false,
          role: args['role'] as String?,
          classId: args['classId'] as String?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.createDeck,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return CreateOrUpdateDeckScreen(
          deckId: args?['deckId'] as String?,
          userId: args?['userId'] as String?,
          initialDeck: args?['initialDeck'] as DeckModel?,
          initialCards: args?['initialCards'] as List<CardModel>?,
          onDelete: args?['onDelete'] as VoidCallback?,
          inClass: args?['inClass'] as bool? ?? false,
          classId: args?['classId'] as String?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.category,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return CategoryScreen(
          category: args['category'] as String,
          decks: args['decks'] as List<DeckModel>,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.rank,
      builder: (context, state) => RankScreen(),
    ),
    GoRoute(
      path: AppRoutes.selfStudy,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return SelfStudyScreen(
          cards: args['cards'] as List<CardModel>,
          question_language: args['question_language'] as String?,
          answer_language: args['answer_language'] as String?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.intermittentStudy,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return IntermittentStudyScreen(
          cards: args['cards'] as List<CardModel>,
          question_language: args['question_language'] as String?,
          answer_language: args['answer_language'] as String?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.multipleChoice,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return MultipleChoiceStudyScreen(
          cards: args['cards'] as List<CardModel>,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.classDetail,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return ClassDetailScreen(
          mClass: args['mClass'] as ClassModel,
          role: args['role'] as String?,
          onDelete: args['onDelete'] as VoidCallback?,
          inviteCode: args['inviteCode'] as String?,
          inClass: args['inClass'] as bool? ?? false,
        );
      },
    ),

    // ── Shell route với bottom navigation bar ─────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const Home(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.decks,
              builder: (context, state) => const DecksControl(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.library,
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.classes,
              builder: (context, state) => const ClassScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const Settings(),
            ),
          ],
        ),
      ],
    ),
  ],
);
