import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QuizPaperModel {
  final String id;
  late final String title;
  String? imageUrl;
  Rxn<String?>? url;
  final String description;
  final int timeSeconds;
  List<Question>? questions;
  final int questionsCount;

  QuizPaperModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.description,
    required this.timeSeconds,
    required this.questions,
    required this.questionsCount,
  });

  String timeInMinits() => "${(timeSeconds / 60).ceil()} mins";

  factory QuizPaperModel.fromString(String jsonString) =>
      QuizPaperModel.fromJson(json.decode(jsonString));

  QuizPaperModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] as String,
        imageUrl = json['image_url'] as String?,
        description = json['Description'] as String,
        timeSeconds = json['time_seconds'] as int,
        questionsCount = 0,

        /// will be update in PapersDataUploader
        questions = json['questions'] == null
            ? []
            : (json['questions'] as List)
                .map(
                    (dynamic e) => Question.fromJson(e as Map<String, dynamic>))
                .toList();
  static Map<String, String> languageCodeToField = {
    'en_US': 'title_en',
    'tr_TR': 'title_tr',
    'es_ES': 'title_es',
    // Diğer diller için de benzer şekilde
  };
  static String getTitleBasedOnLocale(
      DocumentSnapshot<Map<String, dynamic>> snapshot, Locale locale) {
    String localeKey = '${locale.languageCode}_${locale.countryCode}';
    String field = languageCodeToField[localeKey] ?? 'title_en';
    return snapshot.get(field) ?? 'Default Title';
  }

  QuizPaperModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot, Locale locale)
      : id = snapshot.id,
        title = getTitleBasedOnLocale(snapshot, locale),
        imageUrl = snapshot.get('image_url'),
        description = snapshot.get('Description'),
        timeSeconds = snapshot.get('time_seconds'),
        questionsCount = snapshot.get('questions_count') as int,
        questions = [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image_url': imageUrl,
        'Description': description,
        'time_seconds': timeSeconds,
        // 'questions':
        //     questions == null ? [] : questions!.map((e) => e.toJson()).toList()
      };
}

class Question {
  final String id;
  final String question;
  List<Answer> answers;
  final String? correctAnswer;
  String? selectedAnswer;
  bool? draggable;
  final String? imageUrl;
  // Yeni eklenen boolean değişken

  Question({
    required this.id,
    required this.question,
    required this.answers,
    this.correctAnswer,
    this.draggable = false,
    this.imageUrl,
    // Varsayılan değer olarak false atayabilirsiniz
  });

  Question.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        question = snapshot['question'],
        answers = [],
        correctAnswer = snapshot['correct_answer'],
        draggable = snapshot
                .data()
                .containsKey('draggable') // 'draggable' key'ini kontrol et
            ? snapshot['draggable'] as bool // Eğer varsa, bu değeri kullan
            : false, // Eğer yoksa, false olarak atama yap
        imageUrl = snapshot.data().containsKey('imageasd_url')
            ? snapshot['imageasd_url'] as String
            : null;

  Question.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        question = json['question'] as String,
        answers =
            (json['answers'] as List).map((e) => Answer.fromJson(e)).toList(),
        correctAnswer = json['correct_answer'] as String?,
        imageUrl = json['image_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        //'answers' : answers.toJson(),
        'correct_answer': correctAnswer
      };
}

class Answer {
  final String? identifier;
  final String? answer;

  Answer({
    this.identifier,
    this.answer,
  });

  Answer.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'] as String?,
        answer = json['Answer'] as String?;

  Answer.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : identifier = snapshot['identifier'] as String?,
        answer = snapshot['answer'] as String?;

  Map<String, dynamic> toJson() => {'identifier': identifier, 'Answer': answer};
}
