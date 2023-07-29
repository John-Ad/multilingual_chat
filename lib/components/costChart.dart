import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:multilingual_chat/models/chartData.dart';
import 'package:multilingual_chat/models/costTracking.dart';
import 'package:multilingual_chat/services/CostTrackingService.dart';

enum ChartPeriod {
  HOUR,
  DAY,
  WEEK,
  MONTH,
}

class CostChart extends StatefulWidget {
  const CostChart({super.key});

  @override
  State<CostChart> createState() => _CostChartState();
}

class _CostChartState extends State<CostChart> {
  final CostTrackingService _costTrackingService = CostTrackingService();
  List<ChartData> _costs = [];

  @override
  void initState() {
    super.initState();
    _getData24Hrs();
  }

  void _getData24Hrs() async {
    var costs = await _costTrackingService.getCostGroupedBy6Hrs();
    setState(() {
      _costs = costs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                _getData24Hrs();
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
                _getData24Hrs();
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
                _getData24Hrs();
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
                _getData24Hrs();
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
        if (_costs.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            width: 350,
            height: 300,
            child: Chart(
              data: _costs,
              variables: {
                'Time': Variable(
                  accessor: (ChartData data) => "${data.hour}:00",
                ),
                'cost': Variable(
                  accessor: (ChartData data) => data.value,
                ),
              },
              marks: [
                LineMark(
                  shape: ShapeEncode(value: BasicLineShape(dash: [5, 2])),
                  selected: {
                    'touchMove': {1}
                  },
                )
              ],
              coord: RectCoord(color: const Color(0xffdddddd)),
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
      ],
    );
  }
}
