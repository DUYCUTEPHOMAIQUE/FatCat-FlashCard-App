// ignore_for_file: avoid_print

import 'package:FatCat/models/deck_model.dart';
import 'package:FatCat/services/DatabaseHelper.dart';
import 'package:FatCat/services/connectivity_service.dart';
import 'package:FatCat/services/deck_service.dart';
import 'package:FatCat/views/screens/category_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeViewModel extends ChangeNotifier {
  final DeckService deckService = DeckService();
  List<DeckModel> _decks = [];
  String _error = '';
  List<DeckModel> get decks => _decks;
  String get error => _error;

  Future<void> fetchDecks() async {
    try {
      List<DeckModel> decks = await getAllDeck('createdAt DESC');
      _decks = decks;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> openCategoryScreen(BuildContext context, String category) async {
    try {
      List<DeckModel> decks = await deckService.getDecks(category);
      _decks = decks;
      notifyListeners();
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: CategoryScreen(category: category, decks: decks),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } catch (e) {
      print(e);
    }
  }

  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  HomeViewModel() {
    fetchDecks();
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await _connectivityService.checkConnectivity();
    await _updateConnectionStatus(results);
  }

  void _listenToConnectivityChanges() {
    _connectivityService.connectivityStream.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final hasNetworkConnection = results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);

    if (hasNetworkConnection) {
      try {
        // Thử kết nối đến một địa chỉ internet để kiểm tra
        final response = await InternetAddress.lookup('google.com');
        _isConnected = response.isNotEmpty && response[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        _isConnected = false;
      }
    } else {
      _isConnected = false;
    }

    notifyListeners();
  }
}
