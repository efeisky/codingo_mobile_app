import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/model/question_model.dart';

class LessonInformationModel {
  String? subject;
  int? lessonId;
  String? lessonClass;
  LessonEnum? lessonName;
  String? infoXml;
  String? infoVideoSrc;
  List<QuestionModel>? questions;

  LessonInformationModel({
    this.subject,
    this.lessonId,
    this.lessonClass,
    this.lessonName,
    this.infoXml,
    this.infoVideoSrc,
    this.questions
  });
}