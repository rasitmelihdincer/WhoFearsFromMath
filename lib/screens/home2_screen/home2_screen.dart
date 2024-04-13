import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/quiz_paper2/quiz_papers2_controller.dart';

import 'package:flutter_application_2/screens/screens.dart';
import 'package:flutter_application_2/widgets/home/quiz_paper_card2.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class Home2Screen extends GetView {
  const Home2Screen({super.key});

  static const String routeName = '/home2';
  @override
  Widget build(BuildContext context) {
    QuizPaper2Controller quizPaperController = Get.find();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Text(
          "Home2 Screen",
          style: kAppBarTS,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: CustomAppBar().preferredSize.height),
            Padding(
              padding: const EdgeInsets.all(kMobileScreenPadding),
              child: Column(
                  /*
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Builder(
                      builder: (_) {
                        final AuthController auth = Get.find();
                        final user = auth.getUser();
                        String label = '  Hello mate';
                        if (user != null) {
                          label = '  Hello ${user.displayName}';
                        }
                        return Text(
                          label,
                          style:
                              kDetailsTS.copyWith(color: kOnSurfaceTextColor),
                        );
                      },
                    ),
                  ),
                  Obx(() {
                    int totalPoints =
                        controller.getTotalPointsForUser("rstmelih@gmail.com");
                    return Text(
                      ' ${controller.myScores.value?.points} ',
                      style: const TextStyle(fontSize: 18),
                    );
                  }),
                  const SizedBox(height: 15),
                  
                ],
                */
                  ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ContentArea(
                  addPadding: false,
                  child: Obx(
                    () => LiquidPullToRefresh(
                      height: 150,
                      springAnimationDurationInMilliseconds: 500,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      onRefresh: () async {
                        quizPaperController.getAllPapers();
                      },
                      child: ListView.separated(
                        padding: UIParameters.screenPadding,
                        shrinkWrap: true,
                        itemCount: quizPaperController.allPapers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return QuizPaperCard2(
                            model: quizPaperController.allPapers[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
