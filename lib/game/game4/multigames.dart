import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/configs/themes/custom_text_styles.dart';
import 'package:flutter_application_2/widgets/testWidget.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class MultiGames extends StatelessWidget {
  static const id = 'multi_games';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "aaaa",
      home: MultiGames2(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MultiGames2 extends StatefulWidget {
  static const id = 'multi_games';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MultiGames2> {
  /////
  List<bool> buttonVisible = List<bool>.filled(100, true);
  List<int> selectedNumbers = [];
  int? lastAutoSelectedNumber; // Track the last auto-selected number

  void _buttonPressed(int index) {
    int selectedNumber = index + 1;
    if (!buttonVisible[index]) return; // Ignore if the button is already hidden

    setState(() {
      if (checkIfGameShouldEnd()) {
        _endGame(true);
      }
      if (selectedNumbers.isEmpty ||
          isFactorOrMultiple(lastAutoSelectedNumber!, selectedNumber)) {
        selectNumber(selectedNumber);
      } else {
        _endGame(false);
      }
    });
  }

  void selectNumber(int number) {
    buttonVisible[number - 1] = false;
    selectedNumbers.add(number);

    List<int> availableOptions = findAvailableFactorsAndMultiples(number);

    if (availableOptions.isNotEmpty) {
      int randomOption =
          availableOptions[Random().nextInt(availableOptions.length)];
      lastAutoSelectedNumber = randomOption;
      buttonVisible[randomOption - 1] = false;
      selectedNumbers.add(randomOption);
    } else if (selectedNumbers.length > 1) {
      _endGame(true);
    } else {
      lastAutoSelectedNumber = null;
    }
  }

  bool checkIfGameShouldEnd() {
    // Check if the last auto selected number's factors and multiples are all selected
    if (lastAutoSelectedNumber != null) {
      List<int> options =
          findAvailableFactorsAndMultiples(lastAutoSelectedNumber!);
      return options.isEmpty; // Game should end if no available options
    }
    return false; // Continue if no last auto selected number
  }

  bool isFactorOrMultiple(int base, int test) {
    return test % base == 0 || base % test == 0;
  }

  List<int> findAvailableFactorsAndMultiples(int number) {
    Set<int> options = {};
    for (int i = 1; i <= 100; i++) {
      if (i % number == 0 || number % i == 0) {
        options.add(i);
      }
    }
    return options.where((element) => buttonVisible[element - 1]).toList();
  }

  void _endGame(bool won) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(won ? "Congratulations!" : "Game Over"),
          content: Text(won
              ? "You've successfully completed the game!"
              : "Wrong selection or no more moves available!"),
          actions: <Widget>[
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                setState(() {
                  buttonVisible = List<bool>.filled(100, true);
                  selectedNumbers.clear();
                  lastAutoSelectedNumber = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Factors and Multiples Game",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: SafeArea(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex:
                      3, // Allocate a larger part of the screen to this GridView
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return buttonVisible[index]
                          ? Padding(
                              padding:
                                  const EdgeInsets.all(2.0), // Reduced padding
                              child: ElevatedButton(
                                onPressed: () => _buttonPressed(index),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(
                                      6), // Reduced padding inside the button
                                ),
                                child: FittedBox(
                                  // Ensure the text fits in the button
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            )
                          : Container(); // Empty container for invisible buttons
                    },
                  ),
                ),
                Divider(height: 4, color: Colors.white),
                Expanded(
                  flex:
                      1, // Allocate a smaller part of the screen to this GridView
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),
                    itemCount: selectedNumbers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0), // Reduced padding
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(
                                6), // Reduced padding inside the button
                          ),
                          child: FittedBox(
                            // Ensure the text fits in the button
                            child: Text(
                              '${selectedNumbers[index]}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
