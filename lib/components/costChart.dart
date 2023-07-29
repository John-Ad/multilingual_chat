import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:multilingual_chat/models/chartData.dart';
import 'package:multilingual_chat/services/CostTrackingService.dart';

class CostChart extends StatefulWidget {
  const CostChart({super.key});

  @override
  State<CostChart> createState() => _CostChartState();
}

class _CostChartState extends State<CostChart> {
  final CostTrackingService _costTrackingService = CostTrackingService();
  List<ChartData> _costs = [];
  final List<ChartData> _costsTest = [
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

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentMonthsData();
  }

  void _getCurrentMonthsData() async {
    setState(() {
      _loading = true;
    });
    var costs = await _costTrackingService.getCurrentMonthsData();
    setState(() {
      _costs = costs;
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // get width of screen
    var screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                _getCurrentMonthsData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: const Text("Hr", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _getCurrentMonthsData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: const Text("D", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _getCurrentMonthsData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: const Text("W", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _getCurrentMonthsData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: const Text("M", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        if (_costsTest.isNotEmpty && !_loading)
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            width: screenSize.width,
            height: 300,
            child: Chart(
              data: _costsTest,
              variables: {
                '_': Variable(
                  scale: OrdinalScale(
                    formatter: (label) {
                      int costsLength = _costsTest.length;
                      int index = _costsTest.indexWhere(
                        (element) => element.label == label,
                      );

                      if (costsLength <= 6) return label;
                      if (index == 0) return label;
                      if (index == costsLength - 1) return label;
                      if (index == costsLength - 2) return "";

                      int div = (costsLength / 3).toInt();

                      // show every (lenght/4)th label
                      // eg if 20 labels, show every 5th
                      // but not first or last, they are already included
                      if (index % div == 0 && index > 0 && index < costsLength)
                        return label;

                      return "";
                    },
                  ),
                  accessor: (ChartData data) => data.label,
                ),
                'Cost': Variable(
                  accessor: (ChartData data) => data.value,
                ),
                'Day': Variable(
                  accessor: (ChartData data) => data.label,
                ),
              },
              marks: [IntervalMark()],
              axes: [
                Defaults.horizontalAxis,
                Defaults.verticalAxis,
              ],
              selections: {
                'touchMove': PointSelection(
                  on: {
                    GestureType.scaleUpdate,
                    GestureType.tapDown,
                    GestureType.longPressMoveUpdate
                  },
                  dim: Dim.x,
                )
              },
              tooltip: TooltipGuide(
                followPointer: [false, true],
                align: Alignment.topLeft,
                offset: const Offset(-20, -20),
              ),
              crosshair: CrosshairGuide(followPointer: [false, true]),
            ),
          ),
        if (_loading) const CircularProgressIndicator(),
      ],
    );
  }
}
