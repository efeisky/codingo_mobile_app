import 'package:codingo/product/enum/lesson_enums.dart';

class LessonFinishModel {
  String? username;
  String? subject;
  int? lessonId;
  String? lessonClass;
  LessonEnum? lessonName;
  List<Map>? lessonNots;
  Map? lessonResult;
  double? lessonScore;

  LessonFinishModel({
    this.username,
    this.subject,
    this.lessonId,
    this.lessonClass,
    this.lessonName,
    this.lessonNots,
    this.lessonResult,
    this.lessonScore
  });
}