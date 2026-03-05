import 'package:FatCat/models/card_model.dart';
import 'package:FatCat/models/deck_model.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:FatCat/services/card_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreenViewModel extends ChangeNotifier {
  List<DeckModel> _decks;

  CategoryScreenViewModel({required List<DeckModel> decks}) : _decks = decks;

  List<DeckModel> get decks => _decks;
  List<CardModel> _cards = [];

  int get deckCount => _decks.length;
  List<CardModel> get cards => _cards;

  Future<void> getCards(String deckId) async {
    final cards = await CardService().getCardsByDeckId(deckId);
    _cards = cards;
    notifyListeners();
  }

  void routeToSelfStudyScreen(BuildContext context, String deckId) async {
    await getCards(deckId);
    context.push(AppRoutes.selfStudy, extra: {'cards': _cards});
  }

  void routeToIntermittentStudyScreen(BuildContext context, String deckId) async {
    await getCards(deckId);
    context.push(AppRoutes.intermittentStudy, extra: {'cards': _cards});
  }
}
