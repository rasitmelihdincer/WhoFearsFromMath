import 'dart:math';

class QuizBrain {
  var _quizAnswer = '';
  var _quiz = '';
  void makeQuiz() {
    List<String> listOfSigns = ['+', '-', ':', '⋅'];
    Random random = Random();
    var selectedSign = listOfSigns[random.nextInt(listOfSigns.length)];
    var firstNumber = random.nextInt(10) + 10; // from 10 upto 19
    var secondNumber = random.nextInt(9) + 1; // from 1 upto 9  (9 included)
    var realResult;
    switch (selectedSign) {
      case '+':
        realResult = firstNumber + secondNumber;
        break;
      case '-':
        realResult = firstNumber - secondNumber;
        break;
      case '⋅':
        realResult = firstNumber * secondNumber;
        break;
      case ':':
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
    }
    var falseMaker = [-3, -2, -1, 1, 2, 3];
    var randomlyChosen = falseMaker[random.nextInt(falseMaker.length)];
    var trueOrFalseDecision = random.nextInt(2);
    _quizAnswer = 'TRUE';
    if (trueOrFalseDecision == 0) {
      _quizAnswer = 'FALSE';
      realResult = realResult + randomlyChosen;
      if (realResult < 0) realResult = realResult + random.nextInt(2) + 4;
    }
    _quiz = '$firstNumber $selectedSign $secondNumber = $realResult';
  }

  get quizAnswer => _quizAnswer;
  get quiz => _quiz;
}
