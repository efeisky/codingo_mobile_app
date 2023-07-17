import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/enum/lesson_enums.dart';
import 'package:codingo/product/enum/question_enum.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/product/model/question_model.dart';

abstract class IPracticeService{
  Future<List<QuestionModel>?> getPracticeQuestions(String username, LessonEnum lesson);
}

class PracticeService with ProjectDio implements IPracticeService{
  @override
  Future<List<QuestionModel>?> getPracticeQuestions(String username, LessonEnum lesson) async{
    final result = await backService.get(
      DioPaths.getQuestionForPractice.name,
      queryParameters: {
        'username' : username,
        'lessonName' : lesson.name
      }
    );
    if(result.data['status'] == 1 && result.data['incomingValue']['status'] == 1){
      List questionList = result.data['incomingValue']['data'];
      return _parseModeledData(questionList);
    }

    return null;
  }
  
  List<QuestionModel> _parseModeledData(List list){
    return list.map((question) {
      if(question['type'] == QuestionTypes.standart.name){
        return StandartQuestionModel(
          id : question['id'],
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
          id : question['id'],
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
}
