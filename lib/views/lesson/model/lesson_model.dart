import 'package:codingo/product/model/question_model.dart';

class LessonModel {
  bool informationStatus;
  String? videoSrc;
  String? infoXml;
  List<QuestionModel> questions;

  LessonModel({
    required this.informationStatus,
    this.videoSrc,
    this.infoXml,
    required this.questions,
  });
}
