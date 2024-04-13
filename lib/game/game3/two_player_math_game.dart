import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/screens.dart';

class TwoMathGame extends StatefulWidget {
  static const id = 'two_math_game';
  const TwoMathGame({super.key});

  @override
  State<TwoMathGame> createState() => _MathGameState();
}

class _MathGameState extends State<TwoMathGame> {
  int? firstValue;
  int? secondValue;
  String? operator;
  int? correctAnswer;
  List<int> choice = [];
  bool isAnswered = false;
  bool isCorrect = false;
  Player? currentPlayerAnswer;

  int scoreP1 = 0;
  int scoreP2 = 0;
  int totalRound = 0;
  int currentRound = 0;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      showModalRound();
    });

    super.initState();
    restartGame();
  }

  void restartGame() {
    makeQuiz();
    choice.clear();
    choice.add(correctAnswer!);
    while (choice.length < 3) {
      int randomChoice = Random().nextInt(100);
      if (!choice.contains(randomChoice)) {
        choice.add(randomChoice);
      }
    }
    choice.shuffle();
  }

  void makeQuiz() {
    List<String> listOfSigns = ['+', '-', '*', '/'];
    Random random = Random();
    String selectedSign = listOfSigns[random.nextInt(listOfSigns.length)];
    int firstNumber = random.nextInt(10) + 10; // 10 ila 19 arası
    int secondNumber = random.nextInt(9) + 1; // 1 ila 9 arası (9 dahil)
    int realResult;

    // İşlem sonucunu hesapla
    switch (selectedSign) {
      case '+':
        realResult = firstNumber + secondNumber;
        break;
      case '-':
        realResult = firstNumber - secondNumber;
        break;
      case '*':
        realResult = firstNumber * secondNumber;
        break;
      case '/':
        {
          if (firstNumber % secondNumber != 0) {
            if (firstNumber % 2 != 0) firstNumber++;
            for (int i = secondNumber; i > 0; i--) {
              if (firstNumber % i == 0) {
                secondNumber = i;
                break;
              }
            }
          }
          realResult = firstNumber ~/ secondNumber;
        }
        break;
      default:
        throw ArgumentError('Invalid operator');
    }

    firstValue = firstNumber;
    secondValue = secondNumber;
    operator = selectedSign;
    correctAnswer = realResult;

    choice.clear();
    choice.add(correctAnswer!);
    Set<int> answers = {correctAnswer!};
    while (choice.length < 3) {
      int randomChoice;
      do {
        randomChoice = realResult + random.nextInt(5) - 2;
      } while (answers.contains(randomChoice));
      answers.add(randomChoice);
      choice.add(randomChoice);
    }
    choice.shuffle();
  }

  answer({Player? player, index}) {
    if (!isAnswered) {
      setState(() {
        isAnswered = true;
        currentPlayerAnswer = player;
        if (choice.elementAt(index) == correctAnswer) {
          isCorrect = true;
          if (currentPlayerAnswer == Player.p1) {
            scoreP1 = scoreP1 + 10;
          } else {
            scoreP2 = scoreP2 + 10;
          }
        } else {
          isCorrect = false;
        }
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isAnswered = false;
        });
      }).whenComplete(() {
        currentRound = currentRound + 1;
        restartGame();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Container(
                      width: double.infinity,
                      color: Colors.blue,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Round $currentRound",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: DynamicRoundTextWidget(
                                      text:
                                          "$firstValue $operator $secondValue",
                                      textSize: 28,
                                    )),
                                  ),
                                  SizedBox(width: 80)
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "Score",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                scoreP2.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children:
                                      List.generate(choice.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        answer(player: Player.p2, index: index);
                                      },
                                      child: Center(
                                          child: DynamicRoundTextWidget(
                                              text: choice
                                                  .elementAt(index)
                                                  .toString(),
                                              textSize: 24)),
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          Visibility(
                            visible: isAnswered,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                              ),
                              child: currentPlayerAnswer != Player.p2
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isCorrect
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 100,
                                                )
                                              : Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 100,
                                                ),
                                          Text(
                                            isCorrect ? "Correct" : "Wrong",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(1),
                    width: double.infinity,
                    color: Colors.red,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Round $currentRound",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                      child: DynamicRoundTextWidget(
                                    text: "$firstValue $operator $secondValue",
                                    textSize: 28,
                                  )),
                                ),
                                const SizedBox(width: 80)
                              ],
                            ),
                            const Spacer(),
                            Text(
                              "Score",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              scoreP1.toString(),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(choice.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      answer(player: Player.p1, index: index);
                                    },
                                    child: Center(
                                        child: DynamicRoundTextWidget(
                                            text: choice
                                                .elementAt(index)
                                                .toString(),
                                            textSize: 24)),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                        Visibility(
                          visible: isAnswered,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                            ),
                            child: currentPlayerAnswer != Player.p1
                                ? SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isCorrect
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 100,
                                              )
                                            : Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 100,
                                              ),
                                        Text(
                                          isCorrect ? "Correct" : "Wrong",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: totalRound + 1 == currentRound,
            child: Container(
              color: Colors.grey.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      scoreP1 == scoreP2
                          ? ""
                          : scoreP1 > scoreP2
                              ? "PLAYER 1\nWON"
                              : "PLAYER 2\nWON",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                      onPressed: () {
                        setState(() {
                          currentRound = 0;
                          scoreP1 = 0;
                          scoreP2 = 0;
                        });
                        restartGame();
                      },
                      child: Text(
                        "Restart",
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                      onPressed: () {
                        setState(() {
                          currentRound = 0;
                          scoreP1 = 0;
                          scoreP2 = 0;
                        });
                        Navigator.pushReplacementNamed(
                            context, AppIntroductionScreen.routeName);
                      },
                      child: Text(
                        "Go to Home",
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showModalRound() {
    int selectedRound = 5; // Varsayılan olarak 1 seçili olacak

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // Kenarları yuvarlak bir dialog
              ),
              title: Center(child: Text('Total Round')),
              content: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0), // Yatay padding
                child: Column(
                  mainAxisSize: MainAxisSize.min, // İçerik kadar yer kaplasın
                  children: <Widget>[
                    DropdownButton<int>(
                      isExpanded:
                          true, // Dropdown'ın genişliğini maksimuma çıkar
                      value: selectedRound,
                      iconSize: 24, // Dropdown ok ikonunun boyutu
                      elevation: 16, // Gölge derinliği
                      style: TextStyle(
                          color: Colors.deepPurple, fontSize: 20), // Yazı stili
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ), // Alt çizgiyi belirginleştir
                      onChanged: (value) {
                        setState(() {
                          selectedRound = value ?? selectedRound;
                        });
                      },
                      items: List.generate(20, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                fontSize: 20), // Dropdown içindeki yazı boyutu
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20), // Dropdown ve metin arasında boşluk
                    Text('Selected Round: $selectedRound',
                        style: TextStyle(fontSize: 16)), // Seçilen raund metni
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Buton rengi
                    shape: StadiumBorder(), // Yuvarlak kenarlı buton
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    child: Text("Start",
                        style:
                            TextStyle(fontSize: 20)), // Buton metni ve boyutu
                  ),
                  onPressed: () {
                    // Main setState, ana ekrandaki state'i günceller
                    this.setState(() {
                      totalRound = selectedRound;
                      currentRound = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dialog kapatıldıktan sonra, seçilen değeri ekranda göstermek için ana state'i güncelle
      setState(() {});
    });
  }
}

enum Player { p1, p2 }

class RoundTextWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double size;

  const RoundTextWidget({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.size = 60.0, // Varsayılan olarak 50.0 boyutunda bir daire
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle, // Yuvarlak şekil
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.bold, fontSize: 36),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DynamicRoundTextWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double? textSize;

  DynamicRoundTextWidget(
      {Key? key,
      required this.text,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.black,
      required this.textSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseSize = 60.0; // Temel boyut
    double widthMultiplier =
        12.0; // Genişlik çarpanı, metnin uzunluğuna göre ayarla
    double padding = 5.0; // İç boşluk

    // Metin uzunluğuna bağlı olarak width hesapla
    double containerWidth = baseSize + (text.length * widthMultiplier);

    // Yüksekliği sabit tut, genişliği metin uzunluğuna göre ayarla
    return Container(
      width: containerWidth,
      height: baseSize + padding * 2, // Yükseklik, temel boyut + padding
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(baseSize / 2), // Yumuşak kenarlar için
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: padding), // Yatay padding
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.bold, fontSize: textSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
