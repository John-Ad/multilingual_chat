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
        if (_costs.isNotEmpty && !_loading)
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            width: screenSize.width,
            height: 300,
            child: Chart(
              data: _costs,
              variables: {
                'Day': Variable(
                  accessor: (ChartData data) => data.label,
                ),
                'Cost': Variable(
                  accessor: (ChartData data) => data.value,
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
