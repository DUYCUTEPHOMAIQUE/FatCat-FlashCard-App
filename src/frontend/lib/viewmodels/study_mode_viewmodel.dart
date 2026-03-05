import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:FatCat/services/card_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudyModeViewModel extends ChangeNotifier {
  final String deckId;
  List<CardModel> _cards = [];
  StudyModeViewModel({required this.deckId});

  List<CardModel> get cards => _cards;

  Future<void> getCards() async {
    final cards = await CardService().getCardsByDeckId(deckId);
    _cards = cards;
    notifyListeners();
  }

  void routeToSelfStudyScreen(BuildContext context) async {
    await getCards();
    print("############# ${_cards}");
    context.push(AppRoutes.selfStudy, extra: {'cards': _cards});
  }

  void routeToIntermittentStudyScreen(BuildContext context) async {
    await getCards();
    print("############# ${_cards}");
    context.push(AppRoutes.intermittentStudy, extra: {'cards': _cards});
  }
}
