import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_2/configs/themes/app_colors.dart';
import '../constants/constants.dart';
import '../screens/game_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: mainGradient(context),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: AbsorbPointer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Math Quiz \nGame',
                        textAlign: TextAlign.center,
                        textStyle: kAnimationTextStyle,
                        colors: kColorizeAnimationColors,
                      )
                    ],
                    repeatForever: true,
                  ),
                ),
                const Text(
                  'Tap to Start',
                  textAlign: TextAlign.center,
                  style: KTapToStartTextStyle,
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, MathQuizScreen.id);
          },
        ),
      ),
    );
  }
}
