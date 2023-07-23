import 'package:flutter/foundation.dart';
import 'package:multilingual_chat/models/DBContext.dart';
import 'package:multilingual_chat/models/costTracking.dart';
import 'package:multilingual_chat/models/settings.dart';
import 'package:sqflite/sqflite.dart';

enum CostQueryTimeRange {
  hour,
  day,
  week,
  month,
}

class CostTrackingService {
  late Database db;
  bool dbLoaded = false;

  CostTrackingService() {
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

  Future<List<CostTracking>> getAll(CostQueryTimeRange timeRange) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var maxTime = "";

      // get timestamp for hour, day, week, or month
      switch (timeRange) {
        case CostQueryTimeRange.hour:
          maxTime = DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String();
          break;
        case CostQueryTimeRange.day:
          maxTime = DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String();
          break;
        case CostQueryTimeRange.week:
          maxTime = DateTime.now()
              .subtract(const Duration(days: 7))
              .toIso8601String();
          break;
        case CostQueryTimeRange.month:
          maxTime = DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String();
          break;
      }

      var data = await db.query(
        'Cost_Tracking',
        where: 'created_at >= ?',
        whereArgs: [
          maxTime,
        ],
      );

      List<CostTracking> returnData = [];

      for (var element in data) {
        returnData.add(CostTracking.fromMap(element));
      }
      return returnData;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Get cost data err: $e");
      }
      return [];
    }
  }

  Future<bool> add(CostTracking costTracking) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var id = await db.insert('Cost_Tracking', costTracking.toMap());
      if (id == 0) return false;

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Add cost data: $e");
      }
      return false;
    }
  }
}
