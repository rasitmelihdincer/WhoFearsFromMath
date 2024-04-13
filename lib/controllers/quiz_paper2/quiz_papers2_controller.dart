import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/auth_controller.dart';
import 'package:flutter_application_2/firebase/references.dart';
import 'package:flutter_application_2/models/models.dart' show QuizPaperModel;
import 'package:flutter_application_2/screens/screens.dart' show QuizeScreen;
import 'package:flutter_application_2/services/firebase/firebasestorage_service.dart';
import 'package:flutter_application_2/utils/logger.dart';

class QuizPaper2Controller extends GetxController {
  @override
  void onReady() {
    getAllPapers();
    super.onReady();
  }

  final allPapers = <QuizPaperModel>[].obs;
  final allPaperImages = <String>[].obs;

  Future<void> getAllPapers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await quizePaperFR2.get();
      final paperList = data.docs
          .map((paper) => QuizPaperModel.fromSnapshot(paper, Get.locale!))
          .toList();
      allPapers.assignAll(paperList);

      for (var paper in paperList) {
        final imageUrl =
            await Get.find<FireBaseStorageService>().getImage(paper.title);
        paper.imageUrl = imageUrl;
      }
      allPapers.assignAll(paperList);
    } catch (e) {
      AppLogger.e(e);
    }
  }

  void navigatoQuestions(
      {required QuizPaperModel paper, bool isTryAgain = false}) {
    AuthController authController = Get.find();

    if (authController.isLogedIn()) {
      if (isTryAgain) {
        Get.back();
        Get.offNamed(QuizeScreen.routeName,
            arguments: paper, preventDuplicates: false);
      } else {
        Get.toNamed(QuizeScreen.routeName, arguments: paper);
      }
    } else {
      //  authController.showLoginAlertDialog();
    }
  }
}
