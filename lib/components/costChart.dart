import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:multilingual_chat/models/costTracking.dart';
import 'package:multilingual_chat/services/CostTrackingService.dart';

class CostChart extends StatefulWidget {
  const CostChart({super.key});

  @override
  State<CostChart> createState() => _CostChartState();
}

class _CostChartState extends State<CostChart> {
  final CostTrackingService _costTrackingService = CostTrackingService();
  List<CostTracking> _costs = [];

  @override
  void initState() {
    super.initState();
    _getData(CostQueryTimeRange.week);
  }

  void _getData(CostQueryTimeRange costQueryTimeRange) async {
    var costs = await _costTrackingService.getAll(costQueryTimeRange);
    setState(() {
      _costs = costs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 350,
      height: 300,
      child: Chart(
        data: _costs,
        variables: {
          'time': Variable(
            accessor: (CostTracking cost) => cost.createdAt,
            scale: TimeScale(
              formatter: (time) => time.toIso8601String(),
            ),
          ),
          'cost': Variable(
            accessor: (CostTracking cost) => cost.estimatedCost,
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
    );
  }
}
