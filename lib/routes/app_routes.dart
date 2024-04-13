import 'package:flutter_application_2/controllers/quiz_paper2/quiz_papers2_controller.dart';
import 'package:flutter_application_2/screens/auth_and_profile/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/screens/screens.dart';

class AppRoutes {
  static List<GetPage> pages() => [
        GetPage(
          page: () => const SplashScreen(),
          name: SplashScreen.routeName,
        ),
        GetPage(
            page: () => const AppIntroductionScreen(),
            name: AppIntroductionScreen.routeName,
            binding: BindingsBuilder(() {
              Get.put(MyDrawerController());
            })),
        GetPage(
            page: () => const HomeScreen(),
            name: HomeScreen.routeName,
            binding: BindingsBuilder(() {
              Get.put(QuizPaperController());
              //  Get.put(LeaderBoardController());
            })),
        GetPage(
            page: () => const Home2Screen(),
            name: Home2Screen.routeName,
            binding: BindingsBuilder(() {
              Get.put(QuizPaper2Controller());
              //  Get.put(LeaderBoardController());
            })),
        GetPage(page: () => const LoginScreen(), name: LoginScreen.routeName),
        /*
        GetPage(
         //   page: () => LeaderBoardScreen(),
         //   name: LeaderBoardScreen.routeName,
            binding: BindingsBuilder(() {
           //   Get.put(LeaderBoardController());
            })),
            */
        GetPage(
            page: () => const QuizeScreen(),
            name: QuizeScreen.routeName,
            binding: BindingsBuilder(() {
              Get.put<QuizController>(QuizController());
            })),
        GetPage(
            page: () => const AnswersCheckScreen(),
            name: AnswersCheckScreen.routeName),
        GetPage(page: () => const Resultcreen(), name: Resultcreen.routeName),
        GetPage(
          name: SignInScreen.routeName,
          page: () => const SignInScreen(),
        )
      ];
}
