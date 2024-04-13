import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/firebase/references.dart';
import 'package:flutter_application_2/services/notification/notification_service.dart';

extension QuizeResult on QuizController {
  int get correctQuestionCount => allQuestions
      .where((question) => question.selectedAnswer == question.correctAnswer)
      .toList()
      .length;

  String get correctAnsweredQuestions {
    return '$correctQuestionCount out of ${allQuestions.length} are correct';
  }

  int get firstSectionWrongCount {
    return allQuestions
        .sublist(0, 10)
        .where((question) => question.selectedAnswer != question.correctAnswer)
        .length;
  }

  int get secondSectionWrongCount {
    return allQuestions
        .sublist(10, 15)
        .where((question) => question.selectedAnswer != question.correctAnswer)
        .length;
  }

  int get thirdSectionWrongCount {
    return allQuestions
        .sublist(15, 20)
        .where((question) => question.selectedAnswer != question.correctAnswer)
        .length;
  }

  // Sonucu hesaplayan fonksiyon
  int get finalResult {
    int totalWrongCount =
        allQuestions.where((q) => q.selectedAnswer != q.correctAnswer).length;
    // Herhangi bir bölümden 3 veya daha fazla yanlış varsa
    if (firstSectionWrongCount > 2 ||
        secondSectionWrongCount > 2 ||
        thirdSectionWrongCount > 2) {
      return 2;
    }

    // Toplamda tüm bölümlerde 1 yanlış varsa
    if (totalWrongCount == 1) {
      return 1;
    }

    // Birinci bölümde 1 yanlış ve diğer bölümlerden toplamda 1 yanlış varsa
    if (firstSectionWrongCount == 1 &&
        (secondSectionWrongCount + thirdSectionWrongCount) == 1) {
      return 1;
    }

    // Birinci bölümde 1 yanlış, 2. ve 3. bölümden toplamda 2'den fazla yanlış varsa
    if (firstSectionWrongCount == 1 &&
        (secondSectionWrongCount + thirdSectionWrongCount) > 2) {
      return 2;
    }

    // Birinci bölümde 2 yanlış ve diğer bölümler tam doğruysa
    if (firstSectionWrongCount == 2 &&
        secondSectionWrongCount == 0 &&
        thirdSectionWrongCount == 0) {
      return 1;
    }

    // Birinci bölümde 2 yanlış, 2. ve 3. bölümde toplamda 1 veya daha fazla yanlış varsa
    if (firstSectionWrongCount == 2 &&
        (secondSectionWrongCount + thirdSectionWrongCount) >= 1) {
      return 2;
    }

    // Diğer tüm durumlar
    return 1;
  }

  int calculateSectionPoints(
      int sectionStart, int sectionEnd, Map<int, int> pointsPerCorrectAnswer) {
    // Geçerli bölüm aralığından emin ol
    if (sectionStart >= allQuestions.length) {
      // Eğer bölüm başlangıcı liste uzunluğunu geçiyorsa, bu bir hata durumudur.
      // Bu durumda hiç soru yoktur ve 0 puan döndürülebilir.
      return 0;
    }

    // sectionEnd'in listeyi aşmamasını sağla
    int actualEnd =
        sectionEnd <= allQuestions.length ? sectionEnd : allQuestions.length;
    final sectionQuestions = allQuestions.sublist(sectionStart, actualEnd);

    // Eğer sectionQuestions boş ise, 0 puan dön
    if (sectionQuestions.isEmpty) {
      return 0;
    }

    final correctCount = sectionQuestions
        .where((question) => question.selectedAnswer == question.correctAnswer)
        .length;

    // Doğru sayısına göre puanı al
    return pointsPerCorrectAnswer[correctCount] ?? 0;
  }

  // Toplam puan hesaplama
  String get totalPoints {
    // Bölümler için puan matrisi
    // Örneğin: İlk bölüm (0-3 sorular) için 1 doğru 10 puan, 2 doğru 20 puan, 3 doğru 30 puan
    final section1Points = calculateSectionPoints(0, 3, {1: 10, 2: 20, 3: 30});
    final section2Points = calculateSectionPoints(3, 5, {
      1: 30,
      2: 40,
    });
    // Diğer bölümler için benzer bir yapı kurulabilir.
    // Örnek olarak sadece bir bölüm ekledim, diğer bölümleri sizin ihtiyaçlarınıza göre ekleyebilirsiniz.

    // Toplam puanı hesapla
    final totalPoints = section1Points +
        section2Points; // Diğer bölüm puanlarını da buraya ekleyin

    return totalPoints.toString();
  }

  String get points {
    var points = (correctQuestionCount / allQuestions.length) *
        100 *
        (quizPaperModel.timeSeconds - remainSeconds) /
        quizPaperModel.timeSeconds *
        100;
    return points.toStringAsFixed(2);
  }

  Future<void> saveQuizResults() async {
    var batch = fi.batch();
    User? user = Get.find<AuthController>().getUser();
    if (user == null) {
      navigateToHome();
    } else {
      batch.set(
          userFR
              .doc(user.email)
              .collection('myrecent_quizes')
              .doc(quizPaperModel.id),
          {
            "points": points,
            "correct_count": '$correctQuestionCount/${allQuestions.length}',
            "paper_id": quizPaperModel.id,
            "time": quizPaperModel.timeSeconds,
            "quizCompleted": true,
            "finalResult": finalResult, // Burada finalResult değerini ekleyin
          });
      batch.set(
          leaderBoardFR
              .doc(quizPaperModel.id)
              .collection('scores')
              .doc(user.email),
          {
            "points": double.parse(points),
            "correct_count": '$correctQuestionCount/${allQuestions.length}',
            "paper_id": quizPaperModel.id,
            "user_id": user.email,
            "time": quizPaperModel.timeSeconds - remainSeconds,
          });
      await batch.commit();
      /*
    Get.find<NotificationService>().showQuizCompletedNotification(
        id: 1,
        title: quizPaperModel.title,
        body:
            'You have just got $points points for ${quizPaperModel.title} -  Tap here to view leaderboard',
        imageUrl: quizPaperModel.imageUrl,
        payload: json.encode(quizPaperModel.toJson()));
        */

      navigateToHome();
    }
  }
}
