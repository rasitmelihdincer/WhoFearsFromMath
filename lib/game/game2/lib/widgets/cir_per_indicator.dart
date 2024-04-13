import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants/constants.dart';

class CirPerIndicator extends StatelessWidget {
  final percentValue;
  final totalTime;

  const CirPerIndicator({super.key, @required this.totalTime, @required this.percentValue});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 12,
      percent: percentValue,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        '$totalTime',
        style: kTimerTextStyle,
      ),
      progressColor: percentValue > 0.6
          ? Colors.green
          : percentValue > 0.3
              ? Colors.yellow
              : Colors.red,
    );
  }
}
