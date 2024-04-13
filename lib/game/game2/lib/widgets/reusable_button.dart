import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import '../constants/constants.dart';

class ReUsableOutlineButton extends StatelessWidget {
  final userChoice;
  final color;
  final onTap;

  const ReUsableOutlineButton({super.key, 
    @required this.userChoice,
    @required this.color,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: OutlineGradientButton(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gradient: const LinearGradient(
              colors: kGradientColors,
            ),
            strokeWidth: 6,
            elevation: 1,
            radius: const Radius.circular(36),
            onTap: () => onTap(userChoice),
            child: Center(
                child: FittedBox(
              child: Text(
                userChoice,
                style: kButtonTextStyle.copyWith(color: color),
              ),
            ))),
      ),
    );
  }
}
