import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:multilingual_chat/models/chartData.dart';
import 'package:multilingual_chat/models/enums/costTracking.dart';
import 'package:multilingual_chat/services/CostTrackingService.dart';

class CostChart extends StatefulWidget {
  const CostChart({super.key});

  @override
  State<CostChart> createState() => _CostChartState();
}

class _CostChartState extends State<CostChart> {
  final CostTrackingService _costTrackingService = CostTrackingService();
  List<ChartData> _costs = [];
  num _totalCost = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getData(CostTrackingTime.WEEK);
  }

  void _getData(CostTrackingTime type) async {
    setState(() {
      _loading = true;
    });

    List<ChartData> costs = [];

    if (type == CostTrackingTime.WEEK) {
      costs = await _costTrackingService.getCurrentWeeksData();
    }
    if (type == CostTrackingTime.MONTH) {
      costs = await _costTrackingService.getCurrentMonthsData();
    }

    num totalCost = await _costTrackingService.getTotalCost();

    if (mounted == false) return;

    setState(() {
      _costs = costs;
      // _costs = [
      //   ChartData(value: 0.1, label: "1 July"),
      // ];
      _totalCost = totalCost;
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
                _getData(CostTrackingTime.WEEK);
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
                _getData(CostTrackingTime.MONTH);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: Text(
                "Total Cost Over Time: \$${_totalCost < 1 ? _totalCost.toStringAsFixed(6) : _totalCost.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
              ),
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
                '_': Variable(
                  scale: OrdinalScale(
                    formatter: (label) {
                      int costsLength = _costs.length;
                      int index = _costs.indexWhere(
                        (element) => element.label == label,
                      );

                      if (costsLength <= 6) return label;
                      if (index == 0) return label;
                      if (index == costsLength - 1) return label;
                      if (index == costsLength - 2) return "";

                      int div = (costsLength / 3).toInt();

                      // show every (lenght/3)th label
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
                  scale: LinearScale(
                    min: 0,
                  ),
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
