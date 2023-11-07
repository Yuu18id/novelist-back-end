import 'package:flutter_application_1/models/novel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'mydatabase.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          ''' CREATE TABLE users ( id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL UNIQUE,  pass TEXT NOT NULL) ''');
      await db.execute('''
        CREATE TABLE novels(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          author TEXT,
          img TEXT,
          genre TEXT,
          favList TEXT,
          synopsis TEXT,
          isFavorited INTEGER
        )
      ''');
    });
  }

  // Tambahkan fungsi-fungsi berikut untuk mengakses data buku
  Future<void> insertNovel(Novel novel) async {
    final db = await database;
    await db.insert('novels', novel.toMap());
  }

  Future<List<Novel>> getNovels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('novels');
    return List.generate(maps.length, (i) {
      return Novel.fromMap(maps[i]);
    });
  }

  Future<Novel?> getNovelByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'novels',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Novel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Novel?> getNovelById(int novelId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'novels',
      where: 'id = ?',
      whereArgs: [novelId],
    );

    if (maps.isNotEmpty) {
      return Novel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateNovel(Novel novel) async {
    final db = await database;
    await db.update(
      'novels',
      novel.toMap(),
      where: 'name = ?',
      whereArgs: [novel.name],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /* Future<void> updatenovel(Novel novel) async {
    final db = await database;
    await db.update(
      'novels',
      novel.toMap(),
      where: 'id = ?',
      whereArgs: [novel.id],
    );
  } */
}
