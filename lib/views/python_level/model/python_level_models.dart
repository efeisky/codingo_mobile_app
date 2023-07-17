import 'package:codingo/product/model/question_model.dart';

class PythonNotKnowModel {
  String username;
  bool isKnow = false;

  PythonNotKnowModel({
    required this.username,
  });
}

class PythonKnowModel {
  String username;
  int status;
  bool isKnow = true;

  PythonKnowModel({
    required this.username,
    required this.status,
  });
}

class PythonQuestionModel {
  List<QuestionModel> questions;

  PythonQuestionModel({
    required this.questions,
  });
}

