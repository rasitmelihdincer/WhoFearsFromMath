import 'package:flutter/material.dart';

import 'package:flutter_application_2/screens/screens.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class HomeScreen extends GetView {
  const HomeScreen({super.key});

  static const String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    QuizPaperController quizPaperController = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Text(
          "Dyscalculia Test Screen",
          style: kAppBarTS,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: CustomAppBar().preferredSize.height),
            const Padding(
              padding: EdgeInsets.all(kMobileScreenPadding),
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
                          return QuizPaperCard(
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
