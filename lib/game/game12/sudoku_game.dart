import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/widgets/widgets.dart';
import 'dart:math';
import 'package:quiver/iterables.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SudokuGame(),
    );
  }
}

class BoxInner {
  late int index;
  List<BlokChar> blokChars = List<BlokChar>.from([]);

  BoxInner(this.index, this.blokChars);

  // declare method used
  setFocus(int index, Direction direction) {
    List<BlokChar> temp;

    if (direction == Direction.Horizontal) {
      temp = blokChars
          .where((element) => element.index! ~/ 3 == index ~/ 3)
          .toList();
    } else {
      temp = blokChars
          .where((element) => element.index! % 3 == index % 3)
          .toList();
    }

    for (var element in temp) {
      element.isFocus = true;
    }
  }

  setExistValue(
      int index, int indexBox, String textInput, Direction direction) {
    List<BlokChar> temp;

    if (direction == Direction.Horizontal) {
      temp = blokChars
          .where((element) => element.index! ~/ 3 == index ~/ 3)
          .toList();
    } else {
      temp = blokChars
          .where((element) => element.index! % 3 == index % 3)
          .toList();
    }

    if (this.index == indexBox) {
      List<BlokChar> blokCharsBox =
          blokChars.where((element) => element.text == textInput).toList();

      if (blokCharsBox.length == 1 && temp.isEmpty) blokCharsBox.clear();

      temp.addAll(blokCharsBox);
    }

    temp.where((element) => element.text == textInput).forEach((element) {
      element.isExist = true;
    });
  }

  clearFocus() {
    for (var element in blokChars) {
      element.isFocus = false;
    }
  }

  clearExist() {
    for (var element in blokChars) {
      element.isExist = false;
    }
  }
}

enum Direction { Horizontal, Vertical }

class FocusClass {
  int? indexBox;
  int? indexChar;

  setData(int indexBox, int indexChar) {
    this.indexBox = indexBox;
    this.indexChar = indexChar;
  }

  focusOn(int indexBox, int indexChar) {
    return this.indexBox == indexBox && this.indexChar == indexChar;
  }
}

class SudokuGame extends StatefulWidget {
  static const id = 'sudoku_games';
  const SudokuGame({Key? key}) : super(key: key);

  @override
  State<SudokuGame> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuGame> {
  // our variable

  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;

  @override
  void initState() {
    generateSudoku();

    // TODO: implement initState
    super.initState();
  }

  void generateSudoku() {
    isFinish = false;
    focusClass = FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // lets put on ui

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "SUDOKU",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                // height: 400,
                color: Colors.redAccent,
                padding: const EdgeInsets.all(5),
                width: double.maxFinite,
                alignment: Alignment.center,
                child: GridView.builder(
                  itemCount: boxInners.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  physics: const ScrollPhysics(),
                  itemBuilder: (buildContext, index) {
                    BoxInner boxInner = boxInners[index];

                    return Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: GridView.builder(
                        itemCount: boxInner.blokChars.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        physics: const ScrollPhysics(),
                        itemBuilder: (buildContext, indexChar) {
                          BlokChar blokChar = boxInner.blokChars[indexChar];
                          Color color = Colors.white;
                          Color colorText = Colors.black;

                          // change color base condition

                          if (isFinish) {
                            color = Colors.green;
                          } else if (blokChar.isFocus && blokChar.text != "") {
                            color = Colors.brown.shade100;
                          } else if (blokChar.isDefault) {
                            color = Colors.grey.shade400;
                          }

                          if (tapBoxIndex == "$index-$indexChar" && !isFinish) {
                            color = Colors.blue.shade100;
                          }

                          if (isFinish) {
                            colorText = Colors.white;
                          } else if (blokChar.isExist) {
                            colorText = Colors.red;
                          }

                          return Container(
                            color: color,
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: blokChar.isDefault
                                  ? null
                                  : () => setFocus(index, indexChar),
                              child: Text(
                                "${blokChar.text}",
                                style: TextStyle(color: colorText),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: GridView.builder(
                          itemCount: 9,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          physics: const ScrollPhysics(),
                          itemBuilder: (buildContext, index) {
                            return ElevatedButton(
                              onPressed: () => setInput(index + 1),
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => setInput(null),
                        child: Container(
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  generatePuzzle() {
    // install plugins sudoku generator to generate one
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: 32); //54
    // then we populate to get a possible cmbination
    // Quiver for easy populate collection using partition
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList();
    partition(sudokuGenerator.newSudoku,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList()
        .asMap()
        .entries
        .forEach(
      (entry) {
        List<int> tempListCompletes =
            completes[entry.key].expand((element) => element).toList();
        List<int> tempList = entry.value.expand((element) => element).toList();

        tempList.asMap().entries.forEach((entryIn) {
          int index =
              entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() +
                  (entryIn.key % 9).toInt() ~/ 3;

          if (boxInners.where((element) => element.index == index).isEmpty) {
            boxInners.add(BoxInner(index, []));
          }

          BoxInner boxInner =
              boxInners.where((element) => element.index == index).first;

          boxInner.blokChars.add(BlokChar(
            entryIn.value == 0 ? "" : entryIn.value.toString(),
            index: boxInner.blokChars.length,
            isDefault: entryIn.value != 0,
            isCorrect: entryIn.value != 0,
            correctText: tempListCompletes[entryIn.key].toString(),
          ));
        });
      },
    );

    // complte generate puzzle sudoku
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = "$index-$indexChar";
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    // set focus color for line vertical & horizontal
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    for (var element in boxInners) {
      element.clearFocus();
    }

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach(
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal));

    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical));
  }

  setInput(int? number) {
    // set input data based grid
    // or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text ==
            number.toString() ||
        number == null) {
      for (var element in boxInners) {
        element.clearFocus();
        element.clearExist();
      }
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setEmpty();
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    } else {
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setText("$number");

      showSameInputOnSameLine();

      checkFinish();
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    // show duplicate number on same line vertical & horizontal so player know he or she put a wrong value on somewhere

    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    for (var element in boxInners) {
      element.clearExist();
    }

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));

    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();

    if (exists.length == 1) exists[0].isExist = false;
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;

    isFinish = totalUnfinish == 0;

    if (isFinish) {
      // Bulmaca tamamlandığında AlertDialog göster
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations!'),
            content: const Text('You have successfully completed the puzzle.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Try Again'),
                onPressed: () {
                  Navigator.of(context).pop(); // AlertDialog'u kapat
                  generateSudoku(); // Oyunu yeniden başlat
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class BlokChar {
  String? text;
  String? correctText;
  int? index;
  bool isFocus = false;
  bool isCorrect;
  bool isDefault;
  bool isExist = false;

  BlokChar(
    this.text, {
    this.index,
    this.isDefault = false,
    this.correctText,
    this.isCorrect = false,
  });

  // declare method used

  get isCorrectPos => correctText == text;
  setText(String text) {
    this.text = text;
    isCorrect = isCorrectPos;
  }

  setEmpty() {
    text = "";
    isCorrect = false;
  }
}
