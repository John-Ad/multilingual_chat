import 'package:flutter/foundation.dart';
import 'package:multilingual_chat/models/DBContext.dart';
import 'package:multilingual_chat/models/language.dart';
import 'package:sqflite/sqflite.dart';

class LanguagesService {
  late Database db;
  bool dbLoaded = false;

  LanguagesService() {
    init();
  }

  Future<void> init() async {
    try {
      db = await DBContext.database;
    } catch (e) {
      debugPrint("Error: $e");
    }
    dbLoaded = true;
  }

  /// Get All Languages.
  ///
  /// @return List<Language> of languages.
  Future<List<Language>> getAll() async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var languages = await db.query('Language');

      List<Language> result = [];

      for (var element in languages) {
        result.add(Language.fromMap(element));
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Languages getAll: $e");
      }
      return [];
    }
  }
}
