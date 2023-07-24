import 'package:flutter/foundation.dart';
import 'package:multilingual_chat/models/DBContext.dart';
import 'package:multilingual_chat/models/chartData.dart';
import 'package:multilingual_chat/models/costTracking.dart';
import 'package:multilingual_chat/models/openApiUsage.dart';
import 'package:multilingual_chat/models/settings.dart';
import 'package:multilingual_chat/services/GPTService.dart';
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

  /// get all cost data from the last hour, day, week, or month
  ///
  /// @param timeRange The time range to query
  ///
  /// @return a list of CostTracking objects
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

  Future<List<ChartData>> getCostGroupedBy6Hrs() async {
    var daysCostData = await getAll(CostQueryTimeRange.day);
    debugPrint("Day's cost: $daysCostData");

    // from the current hour, get the last 24 hrs
    var currentDateTime = DateTime.now();
    var startHour = currentDateTime.subtract(const Duration(hours: 24)).hour;

    // create 24 costTrack items with average cost of each hour
    var currentHour = startHour;
    List<ChartData> returnData = [];
    for (var i = 0; i < 24; i += 6) {
      if (currentHour > 23) {
        currentHour = 0 + (currentHour - 24);
      }

      var hourCostData = daysCostData
          .where(
            (element) =>
                DateTime.parse(element.createdAt).hour >= currentHour &&
                DateTime.parse(element.createdAt).hour < currentHour + 6,
          )
          .toList();

      debugPrint("Hour cost data: $hourCostData");

      if (hourCostData.isEmpty) {
        returnData.add(ChartData(
          value: 0,
          hour: currentHour,
          day: 0,
          month: 0,
          week: 0,
        ));
      } else {
        var totalCost = 0.0;
        var totalContextCount = 0;
        for (var element in hourCostData) {
          totalCost += element.estimatedCost;
          totalContextCount += element.contextCount;
        }
        returnData.add(ChartData(
          value: totalCost / hourCostData.length,
          hour: currentHour,
          day: 0,
          month: 0,
          week: 0,
        ));
      }

      currentHour += 6;
    }

    return returnData;
  }

  Future<bool> add(OpenApiUsage usage) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var inputCost = usage.promptTokens * GPTService.costPerInputToken;
      var outputCost = usage.completionTokens * GPTService.costPerOutputToken;
      var totalCost = inputCost + outputCost;

      var id = await db.insert(
        'Cost_Tracking',
        {
          "context_count": usage.totalTokens,
          "estimated_cost": totalCost,
        },
      );
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
