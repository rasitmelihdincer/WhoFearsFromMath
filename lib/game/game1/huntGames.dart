import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class HunterGames extends StatelessWidget {
  static const id = 'hunt_games';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Hunt Game', home: GridScreen());
  }
}

class GridScreen extends StatefulWidget {
  static const id = 'hunt_games';
  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final int gridCount = 10;
  Point<int> hiddenPoint = Point(
    Random().nextInt(10), // Rastgele X koordinatı
    Random().nextInt(10), // Rastgele Y koordinatı
  );
  final Map<Point<int>, int> guesses = {};
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();

  Point<int>? lastGuess;
  int lastDistance = -1;

  void checkGuess() {
    final int xGuess = int.tryParse(_xController.text) ?? -1;
    final int yGuess = int.tryParse(_yController.text) ?? -1;
    if (xGuess < 0 ||
        xGuess >= gridCount ||
        yGuess < 0 ||
        yGuess >= gridCount) {
      _showDialog('Invalid Coordinate',
          'Please enter a valid coordinate between 0 and ${gridCount - 1}.');
      return;
    }
    final Point<int> guessPoint = Point(xGuess, yGuess);
    final int distance =
        _calculateDistance(xGuess, yGuess, hiddenPoint.x, hiddenPoint.y);

    setState(() {
      guesses[guessPoint] = distance;

      lastDistance = distance;
      if (distance == 0) {
        _showDialog('Congratulations', 'You have found the treasure!');
      }
    });
  }

  int _calculateDistance(int x1, int y1, int x2, int y2) {
    return (x2 - x1).abs() + (y2 - y1).abs();
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title == 'Congratulations') {
                  // Reset the game after winning
                  setState(() {
                    hiddenPoint = Point(
                      Random().nextInt(10),
                      Random().nextInt(10),
                    );
                    guesses.clear();
                    _xController.clear();
                    _yController.clear();
                  });
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    DynamicValues values = DynamicValues(screenSize); // Ekran boyutunu al
    print(screenSize.height);
    print(screenSize.width);
    double topValue = screenSize.height * 0.01; // Ekran yüksekliğinin %2'si
    double bottomValue = screenSize.height * 0.33; // Ekran yüksekliğinin %30'u
    double leftValue = screenSize.width * 0.08; // Ekran genişliğinin %5'i
    double rightValue = screenSize.width * 0.01; // Ekran genişliğinin %5'i

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Hunt Games",
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.only(top: 4, right: 10),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridCount,
                            childAspectRatio: 1,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            final int x = index % gridCount;
                            final int y = gridCount - 1 - (index ~/ gridCount);
                            final Point<int> point = Point(x, y);
                            final int distance = guesses[point] ?? -1;
                            final bool isHiddenPoint = point == hiddenPoint;
                            final bool isGuessedPoint =
                                guesses.keys.contains(point);
                            Color backgroundColor;
                            if (isHiddenPoint && distance == 0) {
                              backgroundColor = Colors.green;
                            } else if (isGuessedPoint) {
                              backgroundColor = Colors.white;
                            } else {
                              backgroundColor = Colors.transparent;
                            }
                            return GridTile(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  distance >= 0 ? distance.toString() : '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: gridCount * gridCount,
                        ),
                      ),
                    ),
                    Positioned(
                      top: values.topValue,
                      left: values.leftValue,
                      right: values.rightValue,
                      bottom: values.bottomValue,
                      child: CustomPaint(
                        painter: AxisPainter2(gridCount, screenSize),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        iconEnabledColor: Colors.white,
                        value: int.tryParse(_xController.text),
                        decoration: InputDecoration(
                            labelText: 'X Coordinate',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white)),
                        items: List<DropdownMenuItem<int>>.generate(
                          gridCount,
                          (int index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text(index.toString()),
                          ),
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              _xController.text = newValue.toString();
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        iconEnabledColor: Colors.white,
                        value: int.tryParse(_yController.text),
                        decoration: InputDecoration(
                            labelText: 'Y Coordinate',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white)),
                        items: List<DropdownMenuItem<int>>.generate(
                          gridCount,
                          (int index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text(index.toString()),
                          ),
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              _yController.text = newValue.toString();
                            }
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: checkGuess,
                      child: Text('Check'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicValues {
  final Size screenSize;

  DynamicValues(this.screenSize);

  double get topValue => screenSize.height * 0.01; // Sabit bir yüzde

  double get bottomValue {
    if (screenSize.height > 890) {
      return screenSize.height * 0.355;
    } else if (screenSize.height < 595) {
      return screenSize.height * 0.2;
    } else if (screenSize.height < 750) {
      return screenSize.height * 0.19;
    } else if (screenSize.height >= 750 && screenSize.height < 800) {
      return screenSize.height * 0.290;
    } else if (screenSize.height >= 800 && screenSize.height < 850) {
      return screenSize.height * 0.3;
    } else if (screenSize.height < 870) {
      return screenSize.height * 0.340; //0.315
    } else {
      return screenSize.height * 0.320;
    }
  }

  double get leftValue => screenSize.width * 0.08; // Sabit bir yüzde

  double get rightValue => screenSize.width * 0.01; // Sabit bir yüzde
}

class AxisPainter2 extends CustomPainter {
  final int gridCount;
  final Size screenSize;

  AxisPainter2(this.gridCount, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    double fullWidthLineYPosition = screenSize.height * 0.8;
    double strokeWidth = size.width /
        2000; // Örneğin, genişliğe göre dinamik bir stroke genişliği
    double fontSize =
        size.width / 25; // Ekran boyutuna bağlı dinamik font boyutu
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeWidth;
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
    );
    final textSpan = TextSpan(
      text: '',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    canvas.drawLine(Offset(0, size.height - 15),
        Offset(size.width, size.height - 15), paint);

    for (int i = 0; i <= gridCount; i++) {
      final dx = size.width / gridCount * i;
      if (i != 0) {
        canvas.drawCircle(Offset(dx, size.height - 15), 3, paint);
      }
      textPainter.text = TextSpan(text: i == 0 ? '' : '$i', style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(dx - textPainter.width / 2, size.height - 10));

      if (i != 0) {
        canvas.drawLine(Offset(dx, size.height - 15), Offset(dx, 10), paint);
      }
    }

    const yOffset = 16.0;
    canvas.drawLine(Offset(0, 10), Offset(0, size.height), paint);

    for (int i = 0; i <= 9; i++) {
      final dy = size.height / 10 * (gridCount - i) - yOffset;
      if (i != gridCount) {
        canvas.drawCircle(Offset(0, dy), 3, paint);
      }
      textPainter.text =
          TextSpan(text: i == gridCount ? '' : '$i', style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(-8 - textPainter.width, dy - textPainter.height / 2));

      if (i != gridCount) {
        canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
