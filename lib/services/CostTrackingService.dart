import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

  /// Get all cost tracking data for a given year and month
  ///
  /// @param year: int representing the year to get data for
  ///
  /// @param month: int representing the the month to get data for. 1-12
  ///
  /// @return a list of CostTracking objects
  Future<List<CostTracking>> getAllForYearAndMonth(int year, int month) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var startTimestamp = DateTime(year, month).toIso8601String();
      var endTimestamp = DateTime(year, month + 1).toIso8601String();

      var data = await db.query(
        'Cost_Tracking',
        where: 'created_at >= ? and created_at < ?',
        whereArgs: [
          startTimestamp,
          endTimestamp,
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

  /// Group cost tracking data by day for a given year and month.
  /// Will label the grouped data using a readable string for
  /// the day and month.
  ///
  /// @param year: int representing the year to get data for
  ///
  /// @param month: int representing the the month to get data for. 1-12
  ///
  /// @param data: List of CostTracking objects to group
  ///
  /// @return a list of ChartData objects
  Future<List<ChartData>> _groupByDay(
    int year,
    int month,
    List<CostTracking> data,
  ) async {
    Map<String, ChartData> groupedData = {};
    List<ChartData> returnData = [];

    for (var element in data) {
      var date = DateTime.parse(element.createdAt);
      var day = date.day.toString();

      if (groupedData.containsKey(day)) {
        groupedData[day]!.value += element.estimatedCost;
        continue;
      }

      groupedData[day] = ChartData(
        value: element.estimatedCost,
        label: day,
      );
    }

    for (var element in groupedData.entries) {
      var date = DateTime(year, month, int.parse(element.key));
      var label = DateFormat("d MMMM").format(date);
      element.value.label = label;
      returnData.add(element.value);
    }

    return returnData;
  }

  Future<List<ChartData>> getCurrentMonthsData() async {
    var now = DateTime.now();
    var data = await getAllForYearAndMonth(now.year, now.month);
    return _groupByDay(now.year, now.month, data);
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
