import 'dart:io';

import 'package:FatCat/models/class_model.dart';
import 'package:FatCat/services/class_service.dart';
import 'package:FatCat/services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ClassViewModel extends ChangeNotifier {
  ClassViewModel() {
    _initData();
  }

  final ClassService _classService = ClassService();
  bool _isLoading = false;
  List<ClassModel> _ownClasses = [];
  List<ClassModel> _allClasses = [];

  bool get isLoading => _isLoading;
  List<ClassModel> get ownClasses => _ownClasses;
  List<ClassModel> get allClasses => _allClasses;

  Future<void> _initData() async {
    await Future.wait([
      fetchOwnClasses(),
      fetchAllClasses(),
    ]);
  }

  Future<void> fetchOwnClasses() async {
    try {
      _isLoading = true;
      //smooth =))
      await Future.delayed(const Duration(seconds: 1));
      notifyListeners();

      _ownClasses = await _classService.getOwnClasses();
    } catch (e) {
      print('Error fetching own classes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllClasses() async {
    try {
      _isLoading = true;
      notifyListeners();

      _allClasses = await _classService.getAllClasses();
    } catch (e) {
      print('Error fetching all classes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createClass(String name, String description) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _classService.createClass(
        name: name,
        description: description,
      );
      await fetchOwnClasses(); // Refresh the list after creating
    } catch (e) {
      print('Error creating class: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> joinClass(String codeInvite) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _classService.joinClass(codeInvite);
      await fetchOwnClasses(); // Refresh the list after joining
    } catch (e) {
      print('Error joining class: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}