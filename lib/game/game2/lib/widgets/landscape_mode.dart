import 'package:flutter/material.dart';
import '../widgets/reusable_button.dart';
import '../widgets/score_indicators.dart';
import '../widgets/quiz_body.dart';
import '../Widgets/cir_per_indicator.dart';

class LandscapeMode extends StatelessWidget {
  final highscore;
  final score;
  final quizBrainObject;
  final onTap;
  final percentValue;
  final totalTime;
  const LandscapeMode({super.key, 
    @required this.highscore,
    @required this.score,
    @required this.quizBrainObject,
    @required this.onTap,
    @required this.totalTime,
    @required this.percentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReUsableOutlineButton(
          userChoice: 'FALSE',
          color: Colors.white,
          onTap: onTap,
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              ScoreIndicators(highscore: highscore, score: score),
              QuizBody(
                quizBrainObject: quizBrainObject,
              ),
              Expanded(
                flex: 3,
                child: CirPerIndicator(
                  percentValue: percentValue,
                  totalTime: totalTime,
                ),
              ),
            ],
          ),
        ),
        ReUsableOutlineButton(
          userChoice: 'TRUE',
          color: Colors.white,
          onTap: onTap,
        ),
      ],
    );
  }
}
