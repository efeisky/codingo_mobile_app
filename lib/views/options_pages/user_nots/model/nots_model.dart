import 'package:codingo/views/options_pages/user_nots/model/not_content_model.dart';

class NotsModel {
  List<NotContentModel> contentList;
  String lessonName;
  int lessonNumber;

  NotsModel({
    required this.contentList,
    required this.lessonName,
    required this.lessonNumber,
  });
}