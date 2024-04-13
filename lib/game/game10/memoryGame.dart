import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/game/game10/components/info_card.dart';
import 'package:flutter_application_2/game/game10/utils/game_utils.dart';
import 'package:flutter_application_2/widgets/testWidget.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);
  static const id = 'memory_game';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MemoryGame> {
  //setting text style
  TextStyle whiteText = TextStyle(color: Colors.white);
  bool hideTest = false;
  int matchedCardsCount = 0;
  int triesLeft = 24;
  Game _game = Game();

  //game stats
  int tries = 0;
  int score = 0;
  Map<String, String> cardCategories = {
    "assets/shapes/circle.png": "circle",
    "assets/shapes/triangle.png": "circle",
    "assets/shapes/8.png": "üst",
    "assets/shapes/2.png": "üst",
    "assets/shapes/kok16.png": "kök",
    "assets/shapes/4.png": "kök",
    "assets/shapes/3u2.png": "uc",
    "assets/shapes/9.png": "uc",
    "assets/shapes/kok4.png": "kok4",
    "assets/shapes/22.png": "kok4",
    "assets/shapes/kok49.png": "kok7",
    "assets/shapes/7.png": "kok7",
    "assets/shapes/5u2.png": "5u2",
    "assets/shapes/25.png": "5u2",

    // Diğer kartlar ve kategorileri
  };
  void _resetGame() {
    setState(() {
      _game.initGame();
      triesLeft = 24; // Deneme hakkını yeniden 24 yap
      tries = 0;
      score = 0;
      matchedCardsCount = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _game.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "MEMORY GAME",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: GridView.builder(
                      itemCount: _game.gameImg!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      padding: EdgeInsets.all(24.0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print(_game.matchCheck);
                            setState(() {
                              //incrementing the clicks
                              tries++;
                              triesLeft--;
                              _game.gameImg![index] =
                                  _game.shuffledCards[index];
                              _game.matchCheck
                                  .add({index: _game.shuffledCards[index]});

                              print(_game.matchCheck.first);
                            });
                            if (triesLeft == 0) {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Your Trial is Over!"),
                                    content: Text("Press Try Again to Start."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Diyalogu kapat
                                          _resetGame(); // Oyunu sıfırla
                                        },
                                        child: Text("Try Again"),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            }
                            if (_game.matchCheck.length == 2) {
                              // İki kartın kategorisini al
                              var firstCardCategory = cardCategories[
                                  _game.matchCheck[0].values.first];
                              var secondCardCategory = cardCategories[
                                  _game.matchCheck[1].values.first];

                              if (firstCardCategory != null &&
                                  firstCardCategory == secondCardCategory) {
                                print("true");
                                // Doğru eşleşme olduğunda yapılacak işlemler
                                score += 100; // Puanı artır
                                setState(() {
                                  matchedCardsCount +=
                                      2; // Eşleşen kart sayısını artır
                                  // Diğer işlemler
                                });
                                _game.matchCheck.clear();
                                if (matchedCardsCount == _game.cardCount) {
                                  // Tüm kartlar eşleştiğinde
                                  Future.delayed(Duration.zero, () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Congratulations!"),
                                        content: Text(
                                            "You have found all the cards and finished the game!"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Diyalogu kapat
                                              _resetGame(); // Oyunu sıfırla
                                            },
                                            child: Text("Play Again"),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                }
                              } else {
                                print("false");
                                // Yanlış eşleşme olduğunda yapılacak işlemler
                                Future.delayed(Duration(milliseconds: 500), () {
                                  setState(() {
                                    _game.gameImg![_game.matchCheck[0].keys
                                        .first] = _game.hiddenCardpath;
                                    _game.gameImg![_game.matchCheck[1].keys
                                        .first] = _game.hiddenCardpath;
                                    _game.matchCheck.clear();
                                  });
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(_game.gameImg![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      })),
              Text(
                "Right to try: $triesLeft",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
