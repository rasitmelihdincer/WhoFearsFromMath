import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/firebase/references.dart';
import 'package:flutter_application_2/models/models.dart'
    show QuizPaperModel, RecentTest;
import 'package:flutter_application_2/services/firebase/firebasestorage_service.dart';
import 'package:flutter_application_2/utils/logger.dart';

class ProfileController extends GetxController {
  @override
  void onReady() {
    getMyRecentTests();
    super.onReady();
  }

  final allRecentTest = <RecentTest>[].obs;

  Future<void> getMyRecentTests() async {
    try {
      User? user = Get.find<AuthController>().getUser();
      if (user == null) return;
      QuerySnapshot<Map<String, dynamic>> data =
          await recentQuizes(userId: user.email!).get();
      final tests =
          data.docs.map((paper) => RecentTest.fromSnapshot(paper)).toList();

      for (RecentTest test in tests) {
        DocumentSnapshot<Map<String, dynamic>> quizPaperSnapshot =
            await quizePaperFR.doc(test.paperId).get();
        // Burada Get.locale! ekleyerek mevcut dil bilgisini sağlıyoruz.
        final quizPaper =
            QuizPaperModel.fromSnapshot(quizPaperSnapshot, Get.locale!);

        final url =
            await Get.find<FireBaseStorageService>().getImage(quizPaper.title);
        test.papername = quizPaper.title;
        test.paperimage = url;
      }

      allRecentTest.assignAll(tests);
    } catch (e) {
      AppLogger.e(e);
    }
  }
}
