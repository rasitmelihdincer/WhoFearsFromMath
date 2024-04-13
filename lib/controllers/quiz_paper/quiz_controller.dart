import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/auth_controller.dart';
import 'package:flutter_application_2/firebase/firebase_configs.dart';
import 'package:flutter_application_2/models/models.dart';
import 'package:flutter_application_2/screens/screens.dart';
import 'package:flutter_application_2/utils/logger.dart';
import 'package:flutter_application_2/widgets/dialogs/dialogs.dart';

import 'quiz_papers_controller.dart';

class QuizController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;
  final allQuestions = <Question>[];
  late QuizPaperModel quizPaperModel;
  Timer? _timer;
  int remainSeconds = 1;
  final time = '00:00'.obs;
  Rx<String?> draggedAnswer = Rx<String?>(null);

  final RxMap<String, bool> questionAnswerCorrectness = <String, bool>{}.obs;

  void setDraggedAnswer(String? answer) {
    draggedAnswer.value = answer;
    print("Sürüklenen cevap: $answer");
    print("Doğru cevap: ${currentQuestion.value?.correctAnswer}");

    if (answer != null && currentQuestion.value != null) {
      // Sürüklenen cevabın ilk harfini al (örneğin, "A. 555" ise "A" alınır)
      String formattedAnswer = answer.split('.').first.trim();
      print("Formatlanmış sürüklenen cevap: $formattedAnswer");

      bool isCorrect = formattedAnswer.toLowerCase() ==
          currentQuestion.value!.correctAnswer?.trim().toLowerCase();
      questionAnswerCorrectness[currentQuestion.value!.id] = isCorrect;

      if (isCorrect) {
        print("Doğru cevap!");
      } else {
        print("Yanlış cevap!");
      }

      // Kullanıcının seçtiği cevabı ve doğruluğunu güncelle
      currentQuestion.value!.selectedAnswer = formattedAnswer;
      update(['answers_list', 'dragged_answer']);
    }
  }

  void setDraggedAnswer2(String? answer) {
    if (answer != null && currentQuestion.value != null) {
      // Kullanıcının sürükleyip bıraktığı cevabı currentQuestion'un selectedAnswer'ına atayarak güncelle
      currentQuestion.value!.selectedAnswer = answer;
      update(['answers_list']); // İlgili widget'ları güncelle
    }
  }

  @override
  void onReady() {
    final quizePaprer = Get.arguments as QuizPaperModel;
    // loadData(_quizePaprer);
    // loadData2(_quizePaprer);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  Future<bool> onExitOfQuiz() async {
    return Dialogs.quizEndDialog();
  }

  void _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (remainSeconds == 0) {
          timer.cancel();
        } else {
          int minutes = remainSeconds ~/ 60;
          int seconds = (remainSeconds % 60);
          time.value =
              "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
          remainSeconds++;
        }
      },
    );
  }

  void loadData(QuizPaperModel quizPaper) {
    // Firebase çağrılarını kaldır
    quizPaperModel = quizPaper;
    allQuestions.assignAll(quizPaper.questions!);
    currentQuestion.value = quizPaper.questions!.first;
    _startTimer(quizPaper.timeSeconds);
    loadingStatus.value = LoadingStatus.completed;
  }

  void loadDataWithQuestions(
      List<Question> questions, QuizPaperModel quizPaper) {
    quizPaperModel = quizPaper; // QuizPaperModel nesnesini ayarlayın
    allQuestions.assignAll(questions);
    currentQuestion.value = questions.first;
    _startTimer(1); // Örnek olarak 900 saniye verildi
    loadingStatus.value = LoadingStatus.completed;
  }

  Future<QuizPaperModel> loadQuizData(String assetPath) async {
    String jsonString = await rootBundle.loadString(assetPath);
    return QuizPaperModel.fromString(jsonString);
  }

  void loadData2(QuizPaperModel quizPaper) async {
    quizPaperModel = quizPaper;
    loadingStatus.value = LoadingStatus.loading;
    try {
      final QuerySnapshot<Map<String, dynamic>> questionsQuery =
          await quizePaperFR2.doc(quizPaper.id).collection('questions').get();
      final questions = questionsQuery.docs
          .map((question) => Question.fromSnapshot(question))
          .toList();
      quizPaper.questions = questions;
      for (Question _question in quizPaper.questions!) {
        final QuerySnapshot<Map<String, dynamic>> answersQuery =
            await quizePaperFR2
                .doc(quizPaper.id)
                .collection('questions')
                .doc(_question.id)
                .collection('answers')
                .get();
        final answers = answersQuery.docs
            .map((answer) => Answer.fromSnapshot(answer))
            .toList();
        _question.answers = answers;
      }
    } on Exception catch (e) {
      RegExp exp = RegExp(
        r'permission-denied',
        caseSensitive: false,
      );
      if (e.toString().contains(exp)) {
        AuthController authController = Get.find();
        Get.back();
        //   authController.showLoginAlertDialog();
      }
      AppLogger.e(e);
      loadingStatus.value = LoadingStatus.error;
    } catch (e) {
      loadingStatus.value = LoadingStatus.error;
      AppLogger.e(e);
    }

    if (quizPaper.questions != null && quizPaper.questions!.isNotEmpty) {
      allQuestions.assignAll(quizPaper.questions!);
      currentQuestion.value = quizPaper.questions![0];
      _startTimer(quizPaper.timeSeconds);
      loadingStatus.value = LoadingStatus.completed;
    } else {
      loadingStatus.value = LoadingStatus.noReult;
    }
  }

  Rxn<Question> currentQuestion = Rxn<Question>();
  final questionIndex = 0.obs; //_curruntQuestionIndex

  bool get isFirstQuestion => questionIndex.value > 0;

  bool get islastQuestion => questionIndex.value >= allQuestions.length - 1;

  void nextQuestion() {
    if (questionIndex.value >= allQuestions.length - 1) return;
    questionIndex.value++;
    currentQuestion.value = allQuestions[questionIndex.value];

    // Mevcut sorunun 'draggable' değerini kontrol et ve yazdır
    if (currentQuestion.value != null) {
      bool? isDraggable = currentQuestion.value!.draggable;
      print('Current question is draggable: $isDraggable');
    }
  }

  void prevQuestion() {
    if (questionIndex.value <= 0) {
      return;
    }
    questionIndex.value--;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  void jumpToQuestion(int index, {bool isGoBack = true}) {
    questionIndex.value = index;
    currentQuestion.value = allQuestions[index];
    if (isGoBack) {
      Get.back();
    }
  }

  void selectAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    update(['answers_list', 'answers_grid']);
  }

  String get completedQuiz {
    final answeredQuestionCount = allQuestions
        .where((question) => question.selectedAnswer != null)
        .toList()
        .length;
    return '$answeredQuestionCount out of ${allQuestions.length} answered';
  }

  void complete() {
    _timer!.cancel();
    Get.toNamed(Resultcreen.routeName);
  }

  void tryAgain() {
    Get.find<QuizPaperController>()
        .navigatoQuestions(paper: quizPaperModel, isTryAgain: true);
  }

  void navigateToHome() {
    _timer!.cancel();
    Get.offNamedUntil(AppIntroductionScreen.routeName, (route) => false);
  }
}
