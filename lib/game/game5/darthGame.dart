import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class DarthGame2 extends StatelessWidget {
  static const id = 'darth_game';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Matching Game',
      home: DarthGame(),
    );
  }
}

class DarthGame extends StatefulWidget {
  static const id = 'darth_game';
  @override
  _DarthGameState createState() => _DarthGameState();
}

class _DarthGameState extends State<DarthGame> {
  final List<int> numbers = [256, 96, 431, 183, 278, 76, 130, 546];
  final List<int> sums = [408, 439, 301, 622, 182];

  int? firstSelectedNumber;
  String? selectedOperation;
  int? secondSelectedNumber;

  void checkResult(int sum) {
    int result;
    if (selectedOperation == '+') {
      result = firstSelectedNumber! + secondSelectedNumber!;
    } else {
      result = firstSelectedNumber! - secondSelectedNumber!;
    }

    if (result == sum) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have correctly matched the sum $sum.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Try Again!'),
          content: Text('The result is not correct, please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Map<int, int> firstNumbers = {};
  Map<int, String> operations = {};
  Map<int, int> secondNumbers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Dart Game",
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 150),
                child: CustomPaint(
                  size: Size(300, 300), // You can choose a different size
                  painter: MyCustomPainter(numbers: numbers),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: ListView.builder(
                itemCount: sums.length,
                itemBuilder: (context, index) {
                  int sum = sums[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$sum = ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      Flexible(
                        child: Container(
                          width: 100, // Dropdown'ın genişliği
                          child: DropdownButton<int>(
                            iconEnabledColor: Colors.white,
                            isExpanded: true,
                            value: firstNumbers[sum],
                            hint: Text('', style: TextStyle(fontSize: 20)),
                            items:
                                numbers.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value',
                                    style: TextStyle(fontSize: 20)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                firstNumbers[sum] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        child: Container(
                          width: 40, // Dropdown'ın genişliği
                          child: DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            isExpanded: true,
                            value: operations[sum],
                            items: ['+', '-']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:
                                    Text(value, style: TextStyle(fontSize: 20)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                operations[sum] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        child: Container(
                          width: 100, // Dropdown'ın genişliği
                          child: DropdownButton<int>(
                            iconEnabledColor: Colors.white,
                            isExpanded: true,
                            value: secondNumbers[sum],
                            hint: Text('', style: TextStyle(fontSize: 20)),
                            items:
                                numbers.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value'),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                secondNumbers[sum] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: checkAllSums,
              child: Text('Check All Sums'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void checkAllSums() {
    bool allCorrect = true;

    for (int sum in sums) {
      int? firstNumber = firstNumbers[sum];
      String? operation = operations[sum];
      int? secondNumber = secondNumbers[sum];

      if (firstNumber == null || operation == null || secondNumber == null) {
        allCorrect = false;
        break;
      }

      int result = operation == '+'
          ? firstNumber + secondNumber
          : firstNumber - secondNumber;
      if (result != sum) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('All sums are correctly matched.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Great!'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Try Again!'),
          content: Text('Not all sums are correct, please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class MyCustomPainter extends CustomPainter {
  final List<int> numbers;

  MyCustomPainter({required this.numbers});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    // Draw the inner circle
    canvas.drawCircle(size.center(Offset.zero), size.width / 4, paint);

    // Draw the horizontal line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Draw the vertical line
    canvas.drawLine(
      Offset(size.width / 2, -30),
      Offset(size.width / 2, 270),
      paint,
    );
    for (int i = 0; i < numbers.length; i++) {
      final span = TextSpan(
        text: '${numbers[i]}',
        style: textStyle,
      );
      textPainter.text = span;
      textPainter.layout();
      textPainter.paint(
        canvas,
        getOffsetForIndex(i, size, textPainter.size),
      );
    }
  }

  Offset getOffsetForIndex(int index, Size size, Size textSize) {
    // Her çeyrek dairenin merkezi noktalarını hesapla
    final double radius = size.width / 4;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Index'e göre pozisyonu ayarla
    double dx, dy;
    switch (index) {
      case 0: // Sol üst
        dx = centerX - radius - textSize.width / 2;
        dy = centerY - radius - textSize.height / 2;
        break;
      case 1: // Sağ üst
        dx = centerX + radius - textSize.width / 2;
        dy = centerY - radius - textSize.height / 2;
        break;
      case 2: // Sol alt
        dx = centerX - radius - textSize.width / 2;
        dy = centerY + radius - textSize.height / 2;
        break;
      case 3: // Sağ alt
        dx = centerX + radius - textSize.width / 2;
        dy = centerY + radius - textSize.height / 2;
        break;
      case 4: // Üst orta sol
        dx = centerX - radius / 2 - textSize.width / 2;
        dy = centerY - radius - textSize.height / -0.50;
        break;
      case 5: // Üst orta sağ
        dx = centerX + radius / 2 - textSize.width / 2;
        dy = centerY - radius - textSize.height / -0.50;
        break;
      case 6: // Alt orta sol
        dx = centerX - radius / 2 - textSize.width / 2;
        dy = centerY + radius - textSize.height / 0.45;
        break;
      case 7: // Alt orta sağ
        dx = centerX + radius / 2 - textSize.width / 2;
        dy = centerY + radius - textSize.height / 0.45;
        break;
      default:
        dx = dy = 0;
        break;
    }

    return Offset(dx, dy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
