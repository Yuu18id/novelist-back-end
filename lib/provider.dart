import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScreenPageProvider extends ChangeNotifier {

  List _favList = [];

  List get favList => _favList;

  set setFavList(val) {
    _favList.add(val);
    notifyListeners();
  }

  set setFavListDel(val) {
    _favList.removeWhere((innerList) => innerList[0] == val[0] && innerList[1] == val[1]);
    notifyListeners();
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  set login(val) {
    _isLogin = val;
    notifyListeners();
  }

  String _username = '';
  String get username => _username;

  set setUsername(val) {
    _username = val;
    notifyListeners();
  }

  Map user = {
    'data': [
      {'email': 'test@mail.com', 'username': 'test', 'password': 'test123', "favorites" : [], "birthday" : ""},
      {'email': 'bayu@mail.com', 'username': 'bayu', 'password': 'bayu123', "favorites" : [], "birthday" : ""}
    ]
  };

  Map novel = {};

  Future<Map> getNovelData() async {
    final res = await http.get(Uri.parse("https://raw.githubusercontent.com/Yuu18id/resources/main/novel.json"));

    if (res.statusCode == 200) {
        Map novel = json.decode(res.body);
        return novel;
    }
    else {
        throw Exception("Gagal mengambil data");
    }
  }

  DateTime date = DateTime.now();
  bool isDateSet = false;
}