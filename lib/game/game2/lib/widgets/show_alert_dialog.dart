import 'package:flutter/material.dart';
import 'package:flutter_application_2/game/gameScreen.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';

class ShowAlertDialog extends StatelessWidget {
  final score;
  final totalNumberOfQuizzes;
  final startGame;

  const ShowAlertDialog(
      {super.key,
      @required this.score,
      @required this.totalNumberOfQuizzes,
      @required this.startGame});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
        25,
      )),
      backgroundColor: Colors.deepPurple,
      title: const FittedBox(
        child: Text('GAME OVER', textAlign: TextAlign.center, style: kTitleTS),
      ),
      content:
          Text('Score: $score', textAlign: TextAlign.center, style: kContentTS),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            startGame();
            Navigator.of(context).pop();
          },
          child: const Text(
            'PLAY AGAIN',
            style: kDialogButtonsTS,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
