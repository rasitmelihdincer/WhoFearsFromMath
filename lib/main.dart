import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/bindings/initial_binding.dart';
import 'package:flutter_application_2/controllers/Message.dart';
import 'package:flutter_application_2/controllers/common/theme_controller.dart';
import 'package:flutter_application_2/game/game1/huntGames.dart';
import 'package:flutter_application_2/game/game10/memoryGame.dart';

import 'package:flutter_application_2/game/game12/sudoku_game.dart';
import 'package:flutter_application_2/game/game2/lib/screens/game_screen.dart';
import 'package:flutter_application_2/game/game2/lib/screens/welcome_screen.dart';
import 'package:flutter_application_2/game/game3/two_player_math_game.dart';
import 'package:flutter_application_2/game/game4/multigames.dart';
import 'package:flutter_application_2/game/game5/darthGame.dart';

import 'package:flutter_application_2/game/game7/guessoperator.dart';
import 'package:flutter_application_2/game/game8/break_the_code.dart';
import 'package:flutter_application_2/game/game9/game.dart';
import 'package:flutter_application_2/game/game9/models/board_adapter.dart';
import 'package:flutter_application_2/game/gameScreen.dart';
import 'package:flutter_application_2/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFireBase();
  InitialBinding().dependencies();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await Hive.initFlutter();
    Hive.registerAdapter(BoardAdapter());
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      translations: Messages(),
      locale: Locale('en', 'US'), // Varsayılan dil
      fallbackLocale: Locale('en', 'US'),
      title: 'Flutter Demo',
      theme: Get.find<ThemeController>().getLightheme(),
      darkTheme: Get.find<ThemeController>().getDarkTheme(),
      getPages: AppRoutes.pages(),
      debugShowCheckedModeBanner: false,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        GameScreen.id: (context) => const GameScreen(),
        TwoMathGame.id: (context) => const TwoMathGame(),
        MathQuizScreen.id: (context) => const MathQuizScreen(),
        MultiGames2.id: (context) => MultiGames2(),
        GuessOperator.id: (context) => GuessOperator(),
        BreakCode.id: (context) => BreakCode(),
        GridScreen.id: (context) => GridScreen(),
        DarthGame.id: (context) => DarthGame(),
        Game2048.id: (context) => Game2048(),
        MemoryGame.id: (context) => MemoryGame(),
        SudokuGame.id: (context) => SudokuGame()
      },
    );
  }
}

Future<void> initFireBase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
/*
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFireBase();
  runApp(GetMaterialApp(
    home: DataUploaderScreen(),
  ));
}
*/
