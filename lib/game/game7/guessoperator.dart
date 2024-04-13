import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/widgets/common/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuessOperator extends StatelessWidget {
  static const id = 'operator_game'; // Yönlendirme için kullanılacak ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GamePage(), // Oyununuzun ana içeriği
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int number1 = 0;
  int number2 = 0;
  int result = 0;
  String correctOperation = '';
  int score = 0;
  int highScore = 0;
  Timer? timer;
  int timeLeft = 30; // Oyun süresi 30 saniye

  @override
  void initState() {
    super.initState();
    loadHighScore();
    startTimer();
    generateQuestion();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timeLeft = 30; // Her oyun başlangıcında zamanı sıfırla
    timer?.cancel(); // Eğer varsa önceki zamanlayıcıyı iptal et
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        checkHighScore();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Time is Up!'),
            content: Text('Your Score: $score'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: Text('Try Again'),
              ),
            ],
          ),
        );
      }
    });
  }

  void resetGame() {
    score = 0;
    startTimer();
    generateQuestion();
  }

  void generateQuestion() {
    final random = Random();
    number1 = random.nextInt(10) + 1; // 1 ile 10 arası rastgele bir sayı
    number2 = random.nextInt(10) + 1; // 1 ile 10 arası rastgele bir sayı

    final operations = ['+', '-', '*', '/'];
    correctOperation = operations[random.nextInt(operations.length)];

    if (correctOperation == '/') {
      result =
          random.nextInt(10) + 1; // 1 ile 10 arası rastgele bir sonuç değeri
      number1 = result *
          number2; // Böylece bölme işlemi sonucu kesinlikle tam sayı olur
    } else {
      switch (correctOperation) {
        case '+':
          result = number1 + number2;
          break;
        case '-':
          result = number1 - number2;
          break;
        case '*':
          result = number1 * number2;
          break;
      }
    }
  }

  void checkAnswer(String userOperation) {
    if (timeLeft > 0) {
      if (userOperation == correctOperation) {
        score += 10; // Doğru cevap için skor artışı
      }
      generateQuestion(); // Yeni soru üret
      setState(() {});
    }
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }

  void checkHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      await prefs.setInt('highScore', score);
      setState(() {
        highScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    // Ekran yüksekliğinin belirli bir yüzdesini üst padding olarak kullan
    double topPadding = screenHeight * 0.1;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Operator Game",
      ),
      body: Container(
        padding: EdgeInsets.only(top: topPadding),
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Time Left: $timeLeft',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white)),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Skor: $score',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white)),
                SizedBox(
                  width: 20,
                ),
                Text('High Score: $highScore',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            Text('$number1  ?  $number2 = $result',
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(color: Colors.white)),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(20),
              children: <String>['+', '-', '*', '/'].map((String operation) {
                return GestureDetector(
                  onTap: () => checkAnswer(operation),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(45),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        operation,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
