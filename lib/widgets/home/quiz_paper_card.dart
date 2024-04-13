import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_separator/easy_separator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/controllers/quiz_paper/quiz_papers_controller.dart';
import 'package:flutter_application_2/models/quiz_paper_model.dart';
import 'package:flutter_application_2/screens/screens.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class QuizPaperCard extends GetView<QuizPaperController> {
  const QuizPaperCard({super.key, required this.model});

  final QuizPaperModel model;

  @override
  Widget build(BuildContext context) {
    const double padding = 10.0;
    AuthController authController = Get.find<AuthController>();
    User? user = Get.find<AuthController>().getUser();
    return Ink(
      decoration: BoxDecoration(
        borderRadius: UIParameters.cardBorderRadius,
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        borderRadius: UIParameters.cardBorderRadius,
        onTap: () {
          if (user == null) {
            // Kullanıcı giriş yapmamışsa, AlertDialog'u göster
            authController.showLoginAlertDialog(
              onContinueWithoutLogin: () =>
                  controller.navigatoQuestions(paper: model),
            );
          } else {
            // Kullanıcı giriş yapmışsa, doğrudan navigateToQuestions'i çağır
            controller.navigatoQuestions(paper: model);
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          style: cardTitleTs(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 15, right: 50),
                          child: Text(model.description),
                        ),
                      ],
                    ))
                  ],
                ),
                if (user != null)
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.email)
                        .collection('myrecent_quizes')
                        .doc("quizId")
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        var data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        bool quizCompleted = data?["quizCompleted"] ?? false;
                        return Positioned(
                          top: 25,
                          right: 10,
                          child: quizCompleted
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 25,
                                )
                              : SizedBox.shrink(),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
              ],
            )),
      ),
    );
  }
}
