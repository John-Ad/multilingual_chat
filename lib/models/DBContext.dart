import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

/// This class is used to initialize the database.
///
/// It is a singleton class, so only one instance of it can exist.
class DBContext {
  static const int version = 4;
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    try {
      _database = await _initDB();
    } catch (e) {
      debugPrint("Error: $e");
    }
    debugPrint("db: ${_database != null}");
    return _database!;
  }

  static Future<Database> _initDB() async {
    debugPrint("Initializing database...");

    var databasesPath = await getDatabasesPath();
    String path = '${databasesPath}multilingual_chat.db';

    return await openDatabase(path,
        version: version, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static Future _onCreate(Database db, int version) async {
    debugPrint("Creating database...");

    String initSql = await rootBundle.loadString("assets/db/init.sql");

    List<String> statements = initSql.split(";");

    for (var statement in statements) {
      if (statement.trim().isNotEmpty) await db.execute("${statement.trim()};");
    }
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint("Upgrading database...");

    String upgradeSql = await rootBundle.loadString("assets/db/upgrade.sql");

    List<String> statements = upgradeSql.split(";");

    for (var statement in statements) {
      if (statement.trim().isNotEmpty) await db.execute("${statement.trim()};");
    }
  }
}
