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
  final List<ChartData> _costsTestMonth = [
    ChartData(value: 5, label: "1 July"),
    ChartData(value: 10, label: "2 July"),
    ChartData(value: 20, label: "3 July"),
    ChartData(value: 30, label: "4 July"),
    ChartData(value: 40, label: "5 July"),
    ChartData(value: 50, label: "6 July"),
    ChartData(value: 60, label: "7 July"),
    ChartData(value: 70, label: "8 July"),
    ChartData(value: 80, label: "9 July"),
    ChartData(value: 10, label: "10 July"),
    ChartData(value: 20, label: "11 July"),
    ChartData(value: 30, label: "12 July"),
    ChartData(value: 40, label: "13 July"),
    ChartData(value: 50, label: "14 July"),
    ChartData(value: 60, label: "15 July"),
    ChartData(value: 70, label: "16 July"),
    ChartData(value: 80, label: "17 July"),
    ChartData(value: 90, label: "18 July"),
    ChartData(value: 100, label: "19 July"),
    ChartData(value: 110, label: "20 July"),
    ChartData(value: 120, label: "21 July"),
    ChartData(value: 130, label: "22 July"),
    ChartData(value: 140, label: "23 July"),
    ChartData(value: 150, label: "24 July"),
    ChartData(value: 160, label: "25 July"),
    ChartData(value: 170, label: "26 July"),
    ChartData(value: 180, label: "27 July"),
    ChartData(value: 190, label: "28 July"),
    ChartData(value: 200, label: "29 July"),
    ChartData(value: 210, label: "30 July"),
    ChartData(value: 220, label: "31 July"),
  ];

  final List<ChartData> _costsWeek = [
    ChartData(value: 5, label: "1 July"),
    ChartData(value: 10, label: "2 July"),
    ChartData(value: 20, label: "3 July"),
    ChartData(value: 30, label: "4 July"),
    ChartData(value: 40, label: "5 July"),
    ChartData(value: 50, label: "6 July"),
    ChartData(value: 60, label: "7 July"),
    ChartData(value: 70, label: "8 July"),
  ];

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

  Future<List<CostTracking>> getAllForDay() async {
    try {
      if (!dbLoaded) {
        await init();
      }

      // set to 00:00:00 of the current day
      var startTimestamp = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 1, 1)
          .toIso8601String()
          .replaceAll("T", " ");

      var data = await db.query(
        'Cost_Tracking',
        where: 'created_at >= ?',
        whereArgs: [
          startTimestamp,
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

  Future<num> GetUsageForDay() async {
    try {
      var data = await getAllForDay();
      num total = 0;
      for (var element in data) {
        total += element.estimatedCost;
      }
      return total;
    } catch (e) {
      debugPrint("$e");
      return -1;
    }
  }

  /// Get all cost tracking data for the current month
  ///
  /// @return a list of CostTracking objects
  Future<List<CostTracking>> getAllForMonth() async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var startTimestamp = DateTime.now()
          .add(const Duration(days: -31))
          .toIso8601String()
          .replaceAll("T", " ");

      var data = await db.query(
        'Cost_Tracking',
        where: 'created_at >= ?',
        whereArgs: [
          startTimestamp,
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

  Future<num> GetUsageForMonth() async {
    try {
      var data = await getAllForMonth();
      num total = 0;
      for (var element in data) {
        total += element.estimatedCost;
      }
      return total;
    } catch (e) {
      debugPrint("$e");
      return -1;
    }
  }

  Future<List<CostTracking>> getAllForWeek() async {
    try {
      var startTime = DateTime.now()
          .subtract(Duration(days: 7))
          .toIso8601String()
          .replaceAll("T", " ");

      if (!dbLoaded) {
        await init();
      }

      var data = await db.query(
        'Cost_Tracking',
        where: 'created_at >= ?',
        whereArgs: [
          startTime,
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

  Future<num> GetUsageForWeek() async {
    try {
      var data = await getAllForWeek();
      num total = 0;
      for (var element in data) {
        total += element.estimatedCost;
      }
      return total;
    } catch (e) {
      debugPrint("$e");
      return -1;
    }
  }

  /// Group cost tracking data by day
  /// Will label the grouped data using a readable string for
  /// the day and month.
  ///
  /// @param data: List of CostTracking objects to group
  ///
  /// @return a list of ChartData objects
  Future<List<ChartData>> _groupByDay(
    List<CostTracking> data,
  ) async {
    Map<String, ChartData> groupedData = {};
    List<ChartData> returnData = [];

    for (var element in data) {
      var date = DateTime.parse(element.createdAt);

      var key = "${date.day}-${date.month}-${date.year}";

      if (groupedData.containsKey(key)) {
        groupedData[key]!.value += element.estimatedCost;
        continue;
      }

      groupedData[key] = ChartData(
        value: element.estimatedCost,
        label: date.toIso8601String(),
      );
    }

    for (var element in groupedData.entries) {
      var date = DateTime.parse(element.value.label);
      var label = DateFormat("d MMMM").format(date);
      element.value.label = label;
      returnData.add(element.value);
    }

    return returnData;
  }

  Future<List<ChartData>> getCurrentMonthsData() async {
    // return _costsTestMonth;

    var data = await getAllForMonth();
    return _groupByDay(data);
  }

  Future<List<ChartData>> getCurrentWeeksData() async {
    // return _costsWeek;

    var data = await getAllForWeek();
    return _groupByDay(data);
  }

  Future<num> getTotalCost() async {
    try {
      if (!dbLoaded) {
        await init();
      }
      var data = await db.rawQuery(
        'SELECT COALESCE(SUM(estimated_cost), 0) as total FROM Cost_Tracking',
      );

      if (data.isEmpty) return -1;

      return data.first["total"] as num;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Get cost data err: $e");
      }
      return -1;
    }
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
