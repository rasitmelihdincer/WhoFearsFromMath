import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/game/game8/game_engine.dart';
import 'package:flutter_application_2/game/game8/widgets.dart';
import 'package:flutter_application_2/widgets/widgets.dart';
import 'package:get/get.dart';

class BreakCode extends StatefulWidget {
  const BreakCode({Key? key}) : super(key: key);
  static const id = 'break_game';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BreakCode> {
  late GameEngine _gameEngine;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _gameEngine = GameEngine();
  }

  void _handleGenerateNumber() {
    setState(() {
      _gameEngine.generateNumber(_gameEngine.level);
    });
  }

  void _handleLevelUp() {
    setState(() {
      _gameEngine.levelUp();
    });

    if (_gameEngine.isGameCompleted) {
      // Show dialog when game is completed
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You Completed the Game.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                // Optionally, navigate to a different screen or reset the game
              },
              child: const Text('Okey'),
            ),
          ],
        ),
      );
    }
  }

  void _checkAnswer() {
    if (_formKey.currentState!.validate()) {
      final int c1 = int.tryParse(_controller1.text) ?? 0;
      final int c2 = int.tryParse(_controller2.text) ?? 0;
      final int c3 = int.tryParse(_controller3.text) ?? 0;
      if (_gameEngine.isCorrect(
          c1, c2, c3, _gameEngine.add, _gameEngine.multiply)) {
        bool levelUpResult =
            _gameEngine.levelUp(); // Seviye atla ve sonucu kaydet

        if (_gameEngine.isGameCompleted) {
          // Oyun tamamlandı, tebrikler dialogunu göster
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Congratulations!'),
              content: const Text('You Completed the Game.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), // Diyalogu kapat
                  child: const Text('Okey'),
                ),
              ],
            ),
          );
        } else {
          // Oyun devam ediyor, doğru cevap için tebrik mesajı göster
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Congratulations!'),
              content: Text('You did it right. Move to the next level.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Diyalogu kapat
                    _handleGenerateNumber(); // Yeni seviye için sayıları yeniden üret
                  },
                  child: const Text('Okey'),
                ),
              ],
            ),
          );
        }
      } else {
        // Yanlış cevap durumu, hata dialogunu göster
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Wrong!'),
            content: const Text('Please Try Again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(), // Dialog'u kapat
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Break Code Game",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Level: ${_gameEngine.level}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Result of Sums: ${_gameEngine.add}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Result of Multiplications: ${_gameEngine.multiply}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberField(_controller1, 'Number 1'),
                      _buildNumberField(_controller2, 'Number 2'),
                      _buildNumberField(_controller3, 'Number 3'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: const Text('Check Answers'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hoverColor: Colors.white,
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a number';
            } else if (int.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
      ),
    );
  }
}
