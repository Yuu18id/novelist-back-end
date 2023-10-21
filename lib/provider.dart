import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/novel.dart';
import 'package:http/http.dart' as http;

class ScreenPageProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper.instance;
  List<Novel> _novels = [];

  List<Novel> get novels => _novels;

  bool isSearching = false;

  Future<List<Novel>?> initializeNovels() async {
    final dbHelper = DBHelper.instance;

    try {
      final novelData = await getNovelData();

      for (final novelMap in novelData!) {
        final novel = Novel(
          name: novelMap['name'],
          author: novelMap['author'],
          img: novelMap['img'],
          genre: novelMap['genre'],
          synopsis: novelMap['synopsis'],
        );

        // Periksa apakah novel dengan nama yang sama sudah ada dalam database
        final existingNovel = await dbHelper.getNovelByName(novel.name);

        if (existingNovel == null) {
          // Jika novel belum ada, maka masukkan novel baru
          await dbHelper.insertNovel(novel);
        } else {
          // Jika novel sudah ada, perbarui data novel yang ada
          await dbHelper.updateNovel(novel);
        }
      }

      final novels = await dbHelper.getNovels();
      _novels = novels;
      return novels;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getNovelData() async {
    final res = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/Yuu18id/resources/main/novel.json"));

    if (res.statusCode == 200) {
      final decodedData = json.decode(res.body);

      if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey("data")) {
        final novelData = decodedData["data"];

        if (novelData is List &&
            novelData.isNotEmpty &&
            novelData[0] is Map<String, dynamic>) {
          return List<Map<String, dynamic>>.from(novelData);
        }
      }

      throw Exception("Gagal mengambil data: Format data tidak sesuai");
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

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
