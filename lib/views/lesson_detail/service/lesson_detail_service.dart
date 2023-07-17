import 'dart:convert';
import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/lesson_detail/model/lesson_detail_model.dart';

abstract class ILessonDetailService{
  Future<Map?> getLessonDetail (LessonEnum lesson, String username);
}

class LessonDetailService with ProjectDio implements ILessonDetailService {
  Future<Map?> _getLessonDetailFromDb(LessonEnum lesson, String username) async{
    final response = await backService.get(
      DioPaths.getLessonDetailsByLessonName.name,
      queryParameters: {
        'lessonName' : lesson.name,
        'username' : username,
      }
    );
    return response.data['status'] == 1 ? {
      'data' : response.data['lessonDatas'],
      'myLessonID' : response.data['maxValue']
    } : null;
  }

  @override
  Future<Map?> getLessonDetail(LessonEnum lesson, String username) async {
    final lessonDatas = await _getLessonDetailFromDb(lesson, username);
    if (lessonDatas != null) {
        List data = lessonDatas['data'] as List;
        return {
          'lessonDetails': data.map((element) => _parseLessonModel(element)).toList(),
          'myLessonID': lessonDatas['myLessonID'],
        };
    }
    return null;
  }
  
  LessonDetailModel  _parseLessonModel(Map<String, dynamic> data) {
      Map stringJson = {
        'trueAnswerCount' : 0,
        'falseAnswerCount' : 0
      };
      var lData = jsonDecode(data['lessonResult'] ?? jsonEncode(stringJson));
      var lessonDate = data['lessonDate'];
      var parsedTime = lessonDate != null ? DateTime.parse(lessonDate) : DateTime.now();
      return LessonDetailModel(
      id: data['id'],
      subject: data['Subject'],
      classNum: data['Class'],
      questionCount: data['QuestionCount'],
      lessonResult: LessonResult(
        trueAnswerCount: lData['trueAnswerCount'],
        falseAnswerCount: lData['falseAnswerCount'],
      ),
      lessonDate: parsedTime,
    );
  }
}