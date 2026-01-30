// lib/services/database_service.dart
// SQLite database service for storing history and results

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'preferences_service.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  static const String _dbName = 'barbershop.db';
  static const int _dbVersion = 1;
  static const String tableResults = 'results';
  static const String colId = 'id';
  static const String colData = 'data';
  static const String colCreatedAt = 'created_at';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableResults (
        $colId TEXT PRIMARY KEY,
        $colData TEXT NOT NULL,
        $colCreatedAt INTEGER NOT NULL
      )
    ''');
  }

  /// Migrates data from SharedPreferences to SQLite if needed.
  /// Should be called after PreferencesService is initialized.
  Future<void> migrateFromPrefs() async {
    final prefs = PreferencesService.instance;
    // Check if we have history in prefs (Legacy ShoeAI import support if needed, otherwise skip)
    const String historyKey = 'shoe_history_ids';
    final historyIds = prefs.getStringList(historyKey);

    if (historyIds == null || historyIds.isEmpty) {
      return;
    }

    // We don't migrate Shoe data to Barbershop DB automatically to keep clean.
    // Logic removed.
  }

  // CRUD Operations

  Future<void> insertResult(String id, Map<String, dynamic> json) async {
    final db = await database;
    await db.insert(
      tableResults,
      {
        colId: id,
        colData: jsonEncode(json),
        colCreatedAt: DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getResult(String id) async {
    final db = await database;
    final maps = await db.query(
      tableResults,
      columns: [colData],
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      try {
        return jsonDecode(maps.first[colData] as String) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding JSON for id $id: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> deleteResult(String id) async {
    final db = await database;
    await db.delete(
      tableResults,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getHistoryIds() async {
    final db = await database;
    final result = await db.query(
      tableResults,
      columns: [colId],
      orderBy: '$colCreatedAt DESC',
    );
    return result.map((row) => row[colId] as String).toList();
  }

  Future<int> getHistoryCount() async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableResults')) ?? 0;
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableResults);
  }

  Future<bool> hasResult(String id) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM $tableResults WHERE $colId = ?',
      [id],
    ));
    return (count ?? 0) > 0;
  }
}
