import 'package:codingo/product/enum/question_enum.dart';

abstract class QuestionModel {
  int id;
  String content;
  String questionLevel;
  String A;
  String B;
  String C;
  String D;
  int questionAnswer;
  QuestionTypes questionType;

  QuestionModel({
    required this.id,
    required this.content,
    required this.questionLevel,
    required this.A,
    required this.B,
    required this.C,
    required this.D,
    required this.questionAnswer,
    required this.questionType,
  });
}

class StandartQuestionModel extends QuestionModel {
  StandartQuestionModel({
    required int id,
    required String content,
    required String questionLevel,
    required String A,
    required String B,
    required String C,
    required String D,
    required int questionAnswer,
    required QuestionTypes questionType,
  }) : super(
    id: id,
    content: content,
    questionLevel: questionLevel,
    A: A,
    B: B,
    C: C,
    D: D,
    questionAnswer: questionAnswer,
    questionType: questionType,
  );
}

class ImageQuestionModel extends QuestionModel {
  String imagePath;

  ImageQuestionModel({
    required int id,
    required String content,
    required String questionLevel,
    required String A,
    required String B,
    required String C,
    required String D,
    required int questionAnswer,
    required QuestionTypes questionType,
    required this.imagePath,
  }) : super(
    id: id,
    content: content,
    questionLevel: questionLevel,
    A: A,
    B: B,
    C: C,
    D: D,
    questionAnswer: questionAnswer,
    questionType: questionType,
  );
}