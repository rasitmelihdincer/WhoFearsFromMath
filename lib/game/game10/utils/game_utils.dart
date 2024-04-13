import 'package:flutter/material.dart';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  List<Color> cards = [
    Colors.green,
    Colors.yellow,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.blue
  ];
  final String hiddenCardpath = "assets/eswm-logo.png";
  List<String> shuffledCards = [];
  List<String> cards_list = [
    "assets/shapes/2.png",
    "assets/shapes/8.png",
    "assets/shapes/kok16.png",
    "assets/shapes/4.png",
    "assets/shapes/3u2.png",
    "assets/shapes/9.png",
    "assets/shapes/kok4.png",
    "assets/shapes/22.png",
    "assets/shapes/kok49.png",
    "assets/shapes/7.png",
    "assets/shapes/5u2.png",
    "assets/shapes/25.png",
  ];
  Map<String, String> cardCategories = {
    "assets/shapes/circle.png": "circle",
    "assets/shapes/circle_outline.png": "circle",
    // Diğer kartlar ve kategorileri
  };
  final int cardCount = 12;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
    shuffledCards = List.from(cards_list)..shuffle();
  }
}
