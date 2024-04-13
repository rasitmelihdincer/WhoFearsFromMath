import 'dart:math';
import 'package:flutter/foundation.dart';

class GameEngine extends ChangeNotifier {
  var _level = 1;
  int get level => _level;
  late int _add;
  int get add => _add;
  late int _multiply;
  int get multiply => _multiply;
  late int code1 = Random().nextInt(_level) % _level + _level;
  late int code2 = Random().nextInt(_level) % _level + _level;
  late int code3 = Random().nextInt(_level) % _level + _level;

  GameEngine() {
    _add = addCode(code1, code2, code3);
    _multiply = multiplyCode(code1, code2, code3);
  }

  int addCode(int c1, int c2, int c3) {
    return _add = c1 + c2 + c3;
  }

  int multiplyCode(int c1, int c2, int c3) {
    return _multiply = c1 * c2 * c3;
  }

  Future<void> generateNumber(int level) async {
    int code1 = Random().nextInt(level) % level + level;
    int code2 = Random().nextInt(level) % level + level;
    int code3 = Random().nextInt(level) % level + level;
    addCode(code1, code2, code3);
    multiplyCode(code1, code2, code3);

    print('Answer = $code1 - $code2 - $code3');
    print(
        'Randomize = ${addCode(code1, code2, code3)} - ${multiplyCode(code1, code2, code3)}');
    notifyListeners();
  }

  bool levelUp() {
    if (_level < 5) {
      _level++;
      generateNumber(_level);
      notifyListeners();
      return false; // Oyun hala devam ediyor
    } else {
      print('Max level reached');
      return true; // Oyun tamamlandı
    }
  }

  bool isCorrect(int c1, int c2, int c3, int currentAdd, int currentMultiply) {
    if (c1 + c2 + c3 == currentAdd && c1 * c2 * c3 == currentMultiply) {
      return true;
    } else {
      return false;
    }
  }

  bool get isGameCompleted => _level >= 5;
}
