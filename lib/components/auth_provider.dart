import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/db_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> login(String username, String pass) async {
    final db = await DBHelper.instance.database;
    final users = await db.query('users',
        where: 'username = ? AND pass =?', whereArgs: [username, pass]);
    if (users.isNotEmpty) {
      _currentUser = User.fromMap(users.first);
      // throw Exception('Login faile. Invalid usernmae or password.');
      notifyListeners();
    }
  }

  Future<void> register(String username, String pass) async {
    final db = await DBHelper.instance.database;
    try {
      await db.insert('users', {'username': username, 'pass': pass});
      _currentUser = User(username: username, pass: pass);
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
