import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/auth_controller.dart';
import 'package:flutter_application_2/firebase/references.dart';
import 'package:flutter_application_2/models/models.dart' show QuizPaperModel;
import 'package:flutter_application_2/screens/screens.dart' show QuizeScreen;
import 'package:flutter_application_2/services/firebase/firebasestorage_service.dart';
import 'package:flutter_application_2/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPaperController extends GetxController {
  @override
  void onReady() {
    getAllPapers();
    super.onReady();
  }

  final allPapers = <QuizPaperModel>[].obs;
  final allPaperImages = <String>[].obs;

  Future<void> getAllPapers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await quizePaperFR.get();
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
    // Artık kullanıcı giriş yapmış olup olmadığı kontrolünü burada yapmanıza gerek yok,
    // çünkü giriş yapmamış kullanıcılar için de aynı yönlendirme işlemi gerçekleştirilecek.

    if (isTryAgain) {
      // Kullanıcı tekrar denemek istiyorsa, mevcut sayfayı kapatıp quiz sayfasına yönlendir
      Get.back();
      Get.offNamed(QuizeScreen.routeName,
          arguments: paper, preventDuplicates: false);
    } else {
      // Kullanıcı quiz'e başlamak istiyorsa, doğrudan quiz sayfasına yönlendir
      Get.toNamed(QuizeScreen.routeName, arguments: paper);
    }
  }
}
