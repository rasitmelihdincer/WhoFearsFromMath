import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/screens/screens.dart';
import 'package:flutter_application_2/widgets/widgets.dart';
import 'answer_check_screen.dart';

class Resultcreen extends GetView<QuizController> {
  const Resultcreen({super.key});

  static const String routeName = '/resultscreen';

  @override
  Widget build(BuildContext context) {
    final Color textColor = UIParameters.isDarkMode(context)
        ? Colors.white
        : Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: BackgroundDecoration(
          child: Column(
            children: [
              CustomAppBar(
                leading: const SizedBox(
                  height: kToolbarHeight,
                ),
                title: controller.correctAnsweredQuestions,
              ),
              Expanded(
                child: ContentArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        controller.finalResult == 1
                            ? 'NO RISK OF DYSCALCULIA'
                            : 'RISK OF DYSCALCULIA',
                        style:
                            kHeaderTS.copyWith(color: textColor, fontSize: 24),
                      ),
                    ),
                    Text(
                      controller.finalResult == 1
                          ? 'You scored well and the time it took to conclude the test shows that your Maths skills are fluent. Unless you have concerns that your maths skills are significantly lower than your other skills, you do not need a diagnostic assessment of your number skills. However, if you would like to investigate further the possibility of dyscalculia or other specific learning difficulties, it would be helpful to see a specialist.'
                          : 'Your score is low. If you have concerns that your maths skills are significantly lower than your other skills, you should consider having a diagnostic assessment of your number skills by a specialist assessor. ',
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                    Text(
                      "Time to finish  ${controller.time} seconds",
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                        child: GridView.builder(
                            itemCount: controller.allQuestions.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        UIParameters.getWidth(context) ~/ 75,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (_, index) {
                              final question = controller.allQuestions[index];

                              AnswerStatus status = AnswerStatus.notanswered;

                              final selectedAnswer = question.selectedAnswer;
                              final correctAnswer = question.correctAnswer;

                              if (selectedAnswer == correctAnswer) {
                                status = AnswerStatus.correct;
                              } else if (question.selectedAnswer == null) {
                                status = AnswerStatus.wrong;
                              } else {
                                status = AnswerStatus.wrong;
                              }

                              return QuizNumberCard(
                                index: index + 1,
                                status: status,
                                onTap: () {},
                              );
                            }))
                  ],
                )),
              ),
              ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                    padding: UIParameters.screenPadding,
                    child: Row(
                      children: [
                        Expanded(
                            child: MainButton(
                          color: Colors.blueGrey,
                          onTap: () {
                            controller.tryAgain();
                          },
                          title: 'Try Again',
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: MainButton(
                          onTap: () {
                            controller.saveQuizResults();
                          },
                          title: 'Go to home',
                        ))
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
