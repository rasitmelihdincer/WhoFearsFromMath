import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ScoreIndicators extends StatelessWidget {
  final highscore;
  final score;
  const ScoreIndicators({super.key, 
    @required this.highscore,
    @required this.score,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('HIGHSCORE', style: kScoreLabelTextStyle),
                const SizedBox(height: 10),
                Text('$highscore', style: kScoreIndicatorTextStyle),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              children: [
                const Text('SCORE', style: kScoreLabelTextStyle),
                const SizedBox(height: 10),
                Text('$score', style: kScoreIndicatorTextStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
