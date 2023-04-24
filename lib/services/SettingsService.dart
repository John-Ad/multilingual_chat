import 'package:flutter/foundation.dart';
import 'package:german_tutor/models/DBContext.dart';
import 'package:german_tutor/models/conversation.dart';
import 'package:german_tutor/models/settings.dart';
import 'package:sqflite/sqflite.dart';

class SettingsService {
  late Database db;
  bool dbLoaded = false;

  SettingsService() {
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

  /// Get settings
  ///
  /// @return Settings? The settings if they exist, null otherwise.
  Future<Settings?> getSettings() async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var settings = await db.query('Settings', limit: 1);

      return Settings.fromMap(settings[0]);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Get settings: $e");
      }
      return null;
    }
  }

  /// Update settings
  ///
  /// @param settings The settings to update.
  ///
  /// @return bool True if the settings were updated, false otherwise.
  Future<bool> updateSettings(Settings settings) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      await db.update('Settings', settings.toMap());

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Update settings: $e");
      }
      return false;
    }
  }
}
