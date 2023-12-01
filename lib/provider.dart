import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/novel.dart';
import 'package:http/http.dart' as http;

class ScreenPageProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper.instance;
  List<Novel> novels = [];

  bool isSearching = false;
  bool isLogInWithGoogle = false;

  List<Novel> searchResults = [];

  void searchNovels(String query) {
    searchResults.clear();

    // Lakukan pencarian berdasarkan nama novel
    for (final novel in novels) {
      if (novel.name.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(novel);
      }
    }
    notifyListeners();
  }

  void clearNovels() {
    searchResults.clear();
    notifyListeners();
  }

  DateTime date = DateTime.now();
  bool isDateSet = false;
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}
