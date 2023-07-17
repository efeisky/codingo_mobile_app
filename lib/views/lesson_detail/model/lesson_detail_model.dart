class LessonDetailModel {
  int id;
  String subject;
  int classNum;
  int questionCount;
  LessonResult lessonResult;
  DateTime lessonDate;

  LessonDetailModel({
    required this.id,
    required this.subject,
    required this.classNum,
    required this.questionCount,
    required this.lessonResult,
    required this.lessonDate,
  });
}

class LessonResult{
  int trueAnswerCount;
  int falseAnswerCount;

  LessonResult({
    required this.trueAnswerCount,
    required this.falseAnswerCount,
  });
}