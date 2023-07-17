import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/question_enum.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/product/model/question_model.dart';
import 'package:codingo/views/lesson/model/lesson_finish_model.dart';
import 'package:codingo/views/lesson/model/lesson_model.dart';

abstract class ILessonService{
  Future<LessonModel?> getLesson(String username, LessonEnum lesson,int lessonNo, String lessonClass);
  Future<bool> finishLesson(LessonFinishModel model);
}

class LessonService with ProjectDio implements ILessonService{
  
  @override
  Future<LessonModel?> getLesson(String username, LessonEnum lesson, int lessonNo, String lessonClass) async{
    final data = await _checkLessonStatus(username, lesson, lessonNo, lessonClass);
    if (data != null && data != false) {
      final LessonModel lessonData = LessonModel(
        informationStatus: false,
        questions: []
      );

      //Create Info Status
      final bool hasInformation = data['informationValues']['hasInformation'];
      if (hasInformation) {
        lessonData.informationStatus = hasInformation;
        lessonData.videoSrc = data['informationValues']['videoSrc'];
        lessonData.infoXml = data['informationValues']['xml'];
      }

      //CreateQuestionValues
      final List<QuestionModel> questions = _parseModeledData(data['questionValues']);
      lessonData.questions = questions;

      return lessonData;
    }
    return null;
  }
  
  Future _checkLessonStatus(String username, LessonEnum lesson, int lessonNo, String lessonClass) async{
    final result = await backService.get(
      DioPaths.lessonData.name,
      queryParameters: {
        'username' : username,
        'name' : lesson.name,
        'lesClass' : lessonClass,
        'id' : lessonNo,
      }
    );
    if (result.data['status'] == 1) {
      if (result.data['isAvailable'] == 1 && result.data['alreadyTested'] == 0) {
        return result.data;
      } else {
        return false;
      }
    }
    return null;
  }
  
  List<QuestionModel> _parseModeledData(List list){
    return list.map((question) {
      if(question['type'] == QuestionTypes.standart.name){
        return StandartQuestionModel(
          id : question['id'] ?? 0,
          content : question['content'],
          questionLevel : question['questionLevel'],
          A : question['A'],
          B : question['B'],
          C : question['C'],
          D : question['D'],
          questionAnswer : question['questionAnswer'],
          questionType : QuestionTypes.standart,
        );
      }
      else{
        return ImageQuestionModel(
          id : question['id'] ?? 0,
          content : question['content'],
          questionLevel : question['questionLevel'],
          A : question['A'],
          B : question['B'],
          C : question['C'],
          D : question['D'],
          questionAnswer : question['questionAnswer'],
          questionType : QuestionTypes.image,
          imagePath: '',
        );
      }
    }).toList();
  }
  
  @override
  Future<bool> finishLesson(LessonFinishModel model) async{
    return await _finishLessonToDatabase(model);
  }
  
  Future<bool> _finishLessonToDatabase(LessonFinishModel model) async{
    LessonEnum lessonName = model.lessonName ?? LessonEnum.math;
    final result = await backService.post(
      DioPaths.setAfterLesson.name,
      data: {
        'username' : model.username,
        'addedScore' : model.lessonScore,
        'lessonClass' : model.lessonClass,
        'lessonName' : lessonName.name,
        'lessonOrder' : model.lessonId,
        'lessonResult' : model.lessonResult,
        'notValues' : model.lessonNots
      }
    );
    return result.data['status'];
  }
}
