import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/widgets/testWidget.dart';
import 'package:flutter_application_2/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Widgets/landscape_mode.dart';
import '../logics/quizBrain.dart';
import '../widgets/portrait_mode.dart';
import '../widgets/show_alert_dialog.dart';

class MathQuizScreen extends StatefulWidget {
  static const id = 'math_quiz';

  const MathQuizScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<MathQuizScreen> {
  late Timer _timer;
  int _totalTime = 0;
  final QuizBrain _quizBrain = QuizBrain();
  int _score = 0;
  int _highScore = 0;
  double _value = 0;
  int _falseCounter = 0;
  int _totalNumberOfQuizzes = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() async {
    _quizBrain.makeQuiz();
    _startTimer();
    _value = 1;
    _score = 0;
    _falseCounter = 0;
    _totalNumberOfQuizzes = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _highScore = preferences.getInt('highscore') ?? 0;
  }

  void _startTimer() {
    const speed = Duration(milliseconds: 100);
    _timer = Timer.periodic(speed, (timer) {
      if (_value > 0) {
        setState(() {
          _value > 0.005 ? _value -= 0.005 : _value = 0;
          _totalTime = (_value * 20 + 1).toInt();
        });
      } else {
        setState(() {
          _totalTime = 0;
          showMyDialog();
          _timer.cancel();
        });
      }
    });
  }

  void _playSound(String soundName) {
    final player = AudioCache();
    // _player.play(soundName);
  }

  void _checkAnswer(String userChoice) async {
    _totalNumberOfQuizzes++;
    if (userChoice == _quizBrain.quizAnswer) {
      // _playSound('correct-choice.wav');
      _score++;
      _value >= 0.89 ? _value = 1 : _value += 0.1;
      if (_highScore < _score) {
        _highScore = _score;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('highscore', _highScore);
      }
    } else {
      //  _playSound('wrong-choice.wav');
      _falseCounter++;
      _value < 0.02 * _falseCounter
          ? _value = 0
          : _value -= 0.02 * _falseCounter;
    }
    _quizBrain.makeQuiz();
  }

  Future<void> showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ShowAlertDialog(
          score: _score,
          totalNumberOfQuizzes: _totalNumberOfQuizzes,
          startGame: _startGame,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Math Quiz",
      ),
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
              gradient: mainGradient(context),
            ),
            child: SafeArea(
              child: data.width < data.height
                  ? PortraitMode(
                      highscore: _highScore,
                      score: _score,
                      quizBrainObject: _quizBrain,
                      percentValue: _value,
                      totalTime: _totalTime,
                      onTap: _checkAnswer,
                    )
                  : LandscapeMode(
                      highscore: _highScore,
                      score: _score,
                      quizBrainObject: _quizBrain,
                      percentValue: _value,
                      totalTime: _totalTime,
                      onTap: _checkAnswer,
                    ),
            )),
      ]),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
