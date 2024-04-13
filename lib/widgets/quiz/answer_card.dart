import 'package:flutter/material.dart';
import 'package:flutter_application_2/configs/configs.dart';

enum AnswerStatus { correct, wrong, answered, notanswered }

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    Key? key,
    required this.answer,
    this.isSelected = false, // Bu artık kullanılmayacak.
    required this.onTap,
  }) : super(key: key);

  final String answer;
  final bool
      isSelected; // isSelected artık kullanılmayacak, bu yüzden bu kısmı dikkate almayabilirsiniz.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double buttonSize = 60.0; // Dairenin çapı

    return Draggable<String>(
      data: answer,
      feedback: buildButton(context, isDragging: true, buttonSize: buttonSize),
      childWhenDragging: Container(
        width: buttonSize,
        height: buttonSize,
        // Burada istediğiniz bir widget'ı gösterebilirsiniz. Örneğin, Text('') ile tamamen boş bir alan bırakabilirsiniz.
      ),
      child: buildButton(context, isDragging: false, buttonSize: buttonSize),
    );
  }

  Widget buildButton(BuildContext context,
      {required bool isDragging, required double buttonSize}) {
    return ElevatedButton(
      onPressed: onTap, // Butonun tıklanabilirliğini kaldırır
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors
            .purple, // Tıklanabilirlik kaldırıldığı için sabit bir renk kullanılır
        backgroundColor: Theme.of(context).primaryColor,
        shape: CircleBorder(),
        padding: EdgeInsets.all(buttonSize / 2),
      ),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Text(
          answer.length > 2
              ? answer.substring(2)
              : '', // İlk iki karakteri atla
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AnswerCard2 extends StatelessWidget {
  const AnswerCard2({
    Key? key,
    required this.answer,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final String answer;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: UIParameters.cardBorderRadius,
      onTap: () {
        print('AnswerCard2 tapped, isSelected: $isSelected');
        onTap();
      },
      child: Ink(
        child: Text(
          answer,
          style: TextStyle(color: isSelected ? kOnSurfaceTextColor : null),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: UIParameters.cardBorderRadius,
            color: isSelected
                ? answerSelectedColor(context)
                : Theme.of(context).cardColor,
            border: Border.all(
                color: isSelected
                    ? answerSelectedColor(context)
                    : answerBorderColor(context))),
      ),
    );
  }
}

class CorrectAnswerCard extends StatelessWidget {
  const CorrectAnswerCard({
    Key? key,
    required this.answer,
  }) : super(key: key);

  final String answer;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Text(
        answer,
        style: const TextStyle(
            color: kCorrectAnswerColor, fontWeight: FontWeight.bold),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: UIParameters.cardBorderRadius,
        color: kCorrectAnswerColor.withOpacity(0.1),
      ),
    );
  }
}

class WrongAnswerCard extends StatelessWidget {
  const WrongAnswerCard({
    Key? key,
    required this.answer,
  }) : super(key: key);

  final String answer;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Text(
        answer,
        style: const TextStyle(
            color: kWrongAnswerColor, fontWeight: FontWeight.bold),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: UIParameters.cardBorderRadius,
        color: kWrongAnswerColor.withOpacity(0.1),
      ),
    );
  }
}

class NotAnswerCard extends StatelessWidget {
  const NotAnswerCard({
    Key? key,
    required this.answer,
  }) : super(key: key);

  final String answer;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Text(
        answer,
        style: const TextStyle(
            color: kNotAnswerColor, fontWeight: FontWeight.bold),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: UIParameters.cardBorderRadius,
        color: kNotAnswerColor.withOpacity(0.1),
      ),
    );
  }
}
