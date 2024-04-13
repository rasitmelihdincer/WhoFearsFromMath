import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/models/quiz_paper_model.dart';
import 'package:flutter_application_2/screens/home/home_screen.dart';
import 'package:flutter_application_2/screens/home2_screen/home2_screen.dart';
import 'package:flutter_application_2/screens/quiz/result_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/configs/configs.dart';
import 'package:flutter_application_2/controllers/controllers.dart';
import 'package:flutter_application_2/firebase/loading_status.dart';
import 'package:flutter_application_2/screens/quiz/quiz_overview_screen.dart';
import 'package:flutter_application_2/widgets/widgets.dart';

class QuizeScreen extends GetView<QuizController> {
  const QuizeScreen({super.key});

  static const String routeName = '/quizescreen';

  @override
  Widget build(BuildContext context) {
    Future<QuizPaperModel> loadQuizData(String assetPath) async {
      String jsonString = await rootBundle.loadString(assetPath);
      return QuizPaperModel.fromString(jsonString);
    }

    Future<List<Question>> loadAndCombineQuestions() async {
      // Her JSON dosyasından soruları ayrı ayrı yükleyin
      final physicsQuestions =
          await loadQuizData('assets/DB/papers/physics.json')
              .then((value) => value.questions!);
      final biologyQuestions =
          await loadQuizData('assets/DB/papers/bialogy.json')
              .then((value) => value.questions!);
      final chemistryQuestions =
          await loadQuizData('assets/DB/papers/chemistry.json')
              .then((value) => value.questions!);

      // Soru listelerini karıştırın
      physicsQuestions.shuffle();
      chemistryQuestions.shuffle();
      biologyQuestions.shuffle();

      // İstenen sayıda soruyu her kategoriden seçin
      // Ve bu sefer, her kategori için ayrı ayrı ekleyin, karıştırmayın
      final combinedQuestions = <Question>[];
      combinedQuestions.addAll(physicsQuestions.take(10));
      combinedQuestions.addAll(
          biologyQuestions.take(5)); // Biyoloji soruları 10 ile 15 arasında
      combinedQuestions.addAll(
          chemistryQuestions.take(5)); // Kimya soruları 15 ile 20 arasında

      return combinedQuestions;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final combinedQuestions = await loadAndCombineQuestions();
      // QuizPaperModel nesnesini oluşturun
      QuizPaperModel quizPaperModel = QuizPaperModel(
        id: 'quizId', // Örnek ID, gerçek uygulamanızda uygun bir ID kullanın
        title: 'Quiz Title',
        description: 'Quiz Description',
        timeSeconds: 300,
        questions: combinedQuestions,
        questionsCount: combinedQuestions.length,
      );
      controller.loadDataWithQuestions(combinedQuestions, quizPaperModel);
    });
    // Rx<bool?> isDraggable = controller.currentQuestion.value!.draggable.obs;
    // print("ccc  ${isDraggable}");
    RxBool isDraggable = false.obs;
// Firebase'den gelen veriyle güncelleme
    void fetchDraggableValue() {
      // Firebase'den değer çekme işlemi
      var draggableValue = controller
          .currentQuestion.value?.draggable; // Firebase'den gelen değer
      isDraggable.value = draggableValue!;
    }

    return WillPopScope(
      onWillPop: controller.onExitOfQuiz,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const ShapeDecoration(
                shape: StadiumBorder(
                    side: BorderSide(color: kOnSurfaceTextColor, width: 2)),
              ),
              child: Obx(
                () => CountdownTimer(
                  time: controller.time.value,
                  color: kOnSurfaceTextColor,
                ),
              ),
            ),
            titleWidget: Obx(() => Text(
                  '${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
                  style: kAppBarTS,
                )),
          ),
          body: BackgroundDecoration(
            child: Obx(
              () => Column(
                children: [
                  if (controller.loadingStatus.value == LoadingStatus.loading)
                    const Expanded(
                        child: ContentArea(child: QuizScreenPlaceHolder())),
                  if (controller.loadingStatus.value == LoadingStatus.completed)
                    Expanded(
                      child: ContentArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              if (controller.currentQuestion.value?.imageUrl !=
                                  null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    controller.currentQuestion.value!.imageUrl!,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                  ),
                                ),
                              questionTextWithDragTarget(
                                  controller.currentQuestion.value!.question,
                                  context),
                              GetBuilder<QuizController>(
                                id: 'answers_grid',
                                builder: (controller) {
                                  final isDraggable = controller
                                          .currentQuestion.value!.draggable ??
                                      false;
                                  // Eğer draggable true ise GridView kullanarak widget'ları sıralayın
                                  if (isDraggable) {
                                    return GridView.builder(
                                      padding: EdgeInsets.only(top: 80.0),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.7,
                                        // Burada yükseklik/genişlik oranını ayarlayabilirsiniz.
                                        crossAxisSpacing: 15, // Yatay aralık
                                        mainAxisSpacing: 15, // Dikey aralık
                                      ),
                                      itemCount: controller.currentQuestion
                                          .value!.answers.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final answer = controller
                                            .currentQuestion
                                            .value!
                                            .answers[index];
                                        final isSelected = answer.identifier ==
                                            controller.currentQuestion.value!
                                                .selectedAnswer;

                                        return AnswerCard(
                                          isSelected: isSelected,
                                          onTap: () {
                                            controller.selectAnswer(
                                                answer.identifier);
                                          },
                                          answer:
                                              '${answer.identifier}. ${answer.answer}',
                                        );
                                      },
                                    );
                                  } else {
                                    // draggable false ise ListView kullanmaya devam edin
                                    return ListView.separated(
                                      itemCount: controller.currentQuestion
                                          .value!.answers.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(top: 25),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(height: 10);
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final answer = controller
                                            .currentQuestion
                                            .value!
                                            .answers[index];
                                        final isSelected = answer.identifier ==
                                            controller.currentQuestion.value!
                                                .selectedAnswer;
                                        return AnswerCard2(
                                          isSelected: isSelected,
                                          onTap: () {
                                            controller.selectAnswer(
                                                answer.identifier);
                                          },
                                          answer:
                                              '${answer.identifier}. ${answer.answer}',
                                        );
                                      },
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: UIParameters.screenPadding,
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => Visibility(
                                visible: controller.loadingStatus.value ==
                                    LoadingStatus.completed,
                                child: MainButton(
                                  onTap: () {
                                    controller.islastQuestion
                                        ? controller.complete()
                                        : controller.nextQuestion();
                                  },
                                  title: controller.islastQuestion
                                      ? 'Complete'
                                      : 'Next',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget questionTextWithDragTarget(String questionText, BuildContext context) {
    // Soru metninde [ ] işaretini kontrol et
    bool hasDraggableSlot = questionText.contains("[ ]");

    // Eğer [ ] varsa, metni ikiye böl ve DragTarget ile sürüklenebilir alan oluştur
    if (hasDraggableSlot) {
      List<String> parts = questionText.split("[ ]");
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            parts[0],
            style: kQuizeTS,
          ), // [ ] işaretinden önceki metin
          DragTarget<String>(
            onWillAccept: (data) => true,
            onAccept: (data) {
              controller.setDraggedAnswer(
                  data); // QuizController'daki metod çağırılıyor
            },
            builder: (context, candidateData, rejectedData) {
              return Obx(() => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: controller.draggedAnswer.value == null
                            ? Colors.transparent
                            : Theme.of(context).primaryColor,
                        border: Border.all(color: Colors.purple),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: controller.draggedAnswer.value == null ||
                                controller.draggedAnswer.value!.length <= 2
                            ? Text("")
                            : Text(
                                controller.draggedAnswer.value!.substring(
                                    2), // İlk iki karakteri atlayıp kalanını göster
                                style: const TextStyle(
                                    color: Colors
                                        .white, // Text rengini şeffaf yaparak gizleyin
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ));
            },
          ),

          Text(
            parts.length > 1 ? parts[1] : "",
            style: kQuizeTS,
          ), // [ ] işaretinden sonraki metin
        ],
      );
    } else {
      // Eğer [ ] işareti yoksa, normal metni döndür
      return Text(
        questionText,
        style: kQuizeTS,
      );
    }
  }
}
