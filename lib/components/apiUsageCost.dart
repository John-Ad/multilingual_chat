import 'package:flutter/material.dart';
import 'package:multilingual_chat/services/CostTrackingService.dart';

class ApiUsageCost extends StatefulWidget {
  const ApiUsageCost({super.key});

  @override
  State<ApiUsageCost> createState() => _ApiUsageCost();
}

class _ApiUsageCost extends State<ApiUsageCost> {
  final CostTrackingService _costTrackingService = CostTrackingService();

  num totalUsage = 0;
  num todaysUsage = 0;
  num thisWeeksUsage = 0;
  num thisMonthsUsage = 0;

  void _getData() async {
    try {
      var usageTotal = await _costTrackingService.getTotalCost();
      var usageToday = await _costTrackingService.GetUsageForDay();
      var weeksUsage = await _costTrackingService.GetUsageForWeek();
      var monthsUsage = await _costTrackingService.GetUsageForMonth();

      setState(() {
        totalUsage = usageTotal;
        todaysUsage = usageToday;
        thisWeeksUsage = weeksUsage;
        thisMonthsUsage = monthsUsage;
      });
    } catch (e) {
      debugPrint("error getting cost data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total Usage: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                          totalUsage >= 1
                              ? totalUsage.toStringAsFixed(2)
                              : totalUsage.toStringAsFixed(6),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Usage: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                          todaysUsage >= 1
                              ? todaysUsage.toStringAsFixed(2)
                              : todaysUsage.toStringAsFixed(6),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Week's Usage: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                          thisWeeksUsage >= 1
                              ? thisWeeksUsage.toStringAsFixed(2)
                              : thisWeeksUsage.toStringAsFixed(6),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Months's Usage: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                          thisMonthsUsage >= 1
                              ? thisMonthsUsage.toStringAsFixed(2)
                              : thisMonthsUsage.toStringAsFixed(6),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
