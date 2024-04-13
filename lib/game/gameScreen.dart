import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/configs/themes/custom_text_styles.dart';
import 'package:flutter_application_2/game/game1/huntGames.dart';
import 'package:flutter_application_2/game/game10/memoryGame.dart';

import 'package:flutter_application_2/game/game12/sudoku_game.dart';
import 'package:flutter_application_2/game/game2/lib/screens/game_screen.dart';
import 'package:flutter_application_2/game/game2/lib/screens/welcome_screen.dart';
import 'package:flutter_application_2/game/game3/two_player_math_game.dart';
import 'package:flutter_application_2/game/game4/multigames.dart';
import 'package:flutter_application_2/game/game5/darthGame.dart';

import 'package:flutter_application_2/game/game7/guessoperator.dart';
import 'package:flutter_application_2/game/game8/break_the_code.dart';
import 'package:flutter_application_2/game/game9/game.dart';

import 'package:flutter_application_2/widgets/common/custom_app_bar.dart';
import 'package:get/get.dart';

class GameScreen extends StatelessWidget {
  static const id = 'game_screen';
  const GameScreen({super.key});
  void showDetailsDialog(BuildContext context, String detailText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20.0), // Diyalogun kenarlarına yuvarlaklık verir.
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.5), // Diyalogun maksimum yüksekliğini ekran boyutunun %90'ı ile sınırlar.
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Başlık ve çarpı işaretini sağa ve sola yasla.
                    children: [
                      Text(
                        "How To Play",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.deepPurple,
                          size: 24,
                        ), // Çarpı işareti
                        onPressed: () =>
                            Navigator.of(context).pop(), // Diyalogu kapat
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          20), // Başlık ve içerik arasında biraz boşluk bırak.
                  Expanded(
                    // İçeriğin geri kalanının kaydırılabilir olmasını sağlar.
                    child: SingleChildScrollView(
                      child: Text(
                        detailText, // Uzun metin
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Text(
          "Oyunlar".tr,
          style: kAppBarTS,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: ListView(
                children: <Widget>[
                  GameCard(
                      text: "Hunt Games",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "Can you find the hidden treasure?  \nThe treasure has been hidden somewhere,where the grid lines intersect (cross). \nInput coordinates to help find the treasure with the fewest guesses. The interactivity gives you the shortest distance you'd have to travel (along the grid lines) to reach the treasure. \nCan you find a reliable strategy for choosing coordinates that will locate the treasure in the minimum number of guesses? ");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, HunterGames.id);
                      }),
                  GameCard(
                      text: "Memory Game ",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "There are 12 hidden cards on the screen and when you click on one of these cards, it will open and close. Remember the number on the opened card and match it with the corresponding number. Remember you only get 24 tries!");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, MemoryGame.id);
                      }),
                  GameCard(
                      text: "Math Quiz",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "When you enter the game, a counter will start and there will be maths operations on the screen. Calculate whether the results of these operations are correct or incorrect and try to get the highest score before the counter runs out. Remember that every time you get it right you will gain 2 seconds and every time you get it wrong you will lose 1 second. Good luck!");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, MathQuizScreen.id);
                      }),
                  GameCard(
                      text: "Two Player Math Game",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "This game is a two-player game. After choosing a round, put the phone on the table and see the questions with your friend. Whoever answers faster gets the points. When the round is over, the one with the most points wins.");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, TwoMathGame.id);
                      }),
                  GameCard(
                      text: "2048",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "Swipe left, right, up and down to move the tiles. When tiles with the same number touch each other, they merge. Add them together to reach 2048!");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, Game2048.id);
                      }),
                  GameCard(
                      text: "Factors and Multiples Game",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "In this game there are 100 numbers on the screen, select a number and automatically the multiplier or divisor of that number is assigned next to that number. Try to beat the algorithm and don't leave it the factor or divisor of the last number you gave it and win the game");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, MultiGames.id);
                      }),
                  GameCard(
                      text: "Darth Game",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "You will see a dart on the screen and the results below. You have to figure out how to make the results below according to the numbers on the dart. If you are sure about all the operations, click on the check button and check.");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, DarthGame.id);
                      }),
                  GameCard(
                      text: "GuessOperator ",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "When you start the game,there will be a time counting down from 30. You will try to find out which operation is done with the question on the screen. Let's see how many points you can get the highest score");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, GuessOperator.id);
                      }),
                  GameCard(
                      text: "Break Code ",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "In this game you will enter 3 numbers and the sum and multiplication of these 3 numbers you enter must match the numbers written on the screen.Good luck!");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, BreakCode.id);
                      }),
                  GameCard(
                      text: "Sudoku Game ",
                      onPressedButton1: () {
                        showDetailsDialog(context,
                            "A 9×9 square must be filled with numbers from 1 to 9, and each row cannot have a number repeated horizontally or vertically. To push you further, there are 3×3 squares marked on the grid, and each of these squares cannot have repeating numbers.");
                      },
                      onPressedButton2: () {
                        Navigator.pushNamed(context, SudokuGame.id);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String text;
  final VoidCallback onPressedButton1;
  final VoidCallback onPressedButton2;

  const GameCard({
    Key? key,
    required this.text,
    required this.onPressedButton1,
    required this.onPressedButton2,
  }) : super(key: key);

  double _getFontSize(String text) {
    if (text.length > 15) {
      return 13.0;
    } else {
      return 20.0; // Default font size
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = _getFontSize(text);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20.0), // Card'a yuvarlak kenarlar verir
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(
              20.0), // Container'a da aynı yuvarlak köşeleri uygula
        ),
        height: 80,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Sol tarafta metin alanı
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 8.0), // Butonlarla metin arasında boşluk bırak
                child: Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          fontSize, // MediaQuery veya LayoutBuilder ile dinamik hale getirilebilir
                      color: kOnSurfaceTextColor),
                  overflow: TextOverflow.ellipsis, // Uzun metin kesilecek
                ),
              ),
            ),
            // Sağ tarafta butonlar

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: onPressedButton1, // İkonun rengini değiştir
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Butonun arkaplan rengini değiştir
                    shape:
                        MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                  ),
                  child: const Icon(
                    Icons.question_mark_outlined,
                    color: Colors.deepPurple,
                    size: 25,
                  ),
                ),
                ElevatedButton(
                  onPressed: onPressedButton2, // İkonun rengini değiştir
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Butonun arkaplan rengini değiştir
                    shape:
                        MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.deepPurple,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
