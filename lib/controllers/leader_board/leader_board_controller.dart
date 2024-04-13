import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/auth_controller.dart';
import 'package:flutter_application_2/firebase/loading_status.dart';
import 'package:flutter_application_2/firebase/references.dart';
import 'package:flutter_application_2/models/models.dart';
import 'package:flutter_application_2/utils/logger.dart';
/*
class LeaderBoardController extends GetxController {
  
  final leaderBoard = <LeaderBoardData>[].obs;
  final myScores = Rxn<LeaderBoardData>();
  final loadingStatus = LoadingStatus.completed.obs;

  int getTotalPointsForUser(String userId) {
    int totalPoints = 0;

    // leaderBoard'daki her bir öğeyi döngü ile kontrol edin
    for (var data in leaderBoard) {
      // Belirli kullanıcının verilerini kontrol edin
      if (data.userId == userId) {
        // Eğer belirli bir kullanıcıya aitse puanları toplayın
        totalPoints += data.points?.toInt() ?? 0;
      }
    }

    return totalPoints;
  }

  void getAll(String paperId) async {
    loadingStatus.value = LoadingStatus.loading;
    try {
      final QuerySnapshot<Map<String, dynamic>> leaderBoardSnapShot =
          await getleaderBoard(paperId: paperId)
              .orderBy("points", descending: true)
              .limit(50)
              .get();
      final allData = leaderBoardSnapShot.docs
          .map((score) => LeaderBoardData.fromSnapShot(score))
          .toList();

      for (var data in allData) {
        final userSnapshot = await userFR.doc(data.userId).get();
        data.user = UserData.fromSnapShot(userSnapshot);
      }

      leaderBoard.assignAll(allData);
      loadingStatus.value = LoadingStatus.completed;
    } catch (e) {
      loadingStatus.value = LoadingStatus.error;
      AppLogger.e(e);
    }
  }

  void getMyScores(String paperId) async {
    final user = Get.find<AuthController>().getUser();

    if (user == null) {
      return;
    }
    try {
      final DocumentSnapshot<Map<String, dynamic>> leaderBoardSnapShot =
          await getleaderBoard(paperId: paperId).doc(user.email).get();
      final _myScores = LeaderBoardData.fromSnapShot(leaderBoardSnapShot);
      _myScores.user = UserData(name: user.displayName!, image: user.photoURL);
      myScores.value = _myScores;
    } catch (e) {
      AppLogger.e(e);
    }
  }
}
*/
