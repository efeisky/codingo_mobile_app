import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/enum/question_enum.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/product/model/question_model.dart';
import 'package:codingo/views/python_level/model/python_level_models.dart';
import 'package:codingo/views/python_level/model/python_machine_model.dart';

abstract class IPythonLevelService{
  Future<PythonQuestionModel?> getQuestions();
  Future<PythonMachineModel?> controlPythonLevel(List<Map> data);
  Future<bool> setPythonLevel(PythonKnowModel model);
  Future<bool> notKnowPython(PythonNotKnowModel model);
}

class PythonLevelService with ProjectDio implements IPythonLevelService{
  
  @override
  Future<PythonQuestionModel?> getQuestions() async{
    final result = await backService.get(
      DioPaths.getQuestion.name,
    );
    if (result.data['status'] == 1) {
      final List<QuestionModel> questions = _parseModeledData(result.data['questionValues']);
      return PythonQuestionModel(questions: questions);
    } else {
      return null;
    }
  }
  
  List<QuestionModel> _parseModeledData(List list){
    return list.map((question) {
      if(question['type'] == QuestionTypes.standart.name){
        return StandartQuestionModel(
          id : question['questionID'] ?? 0,
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
  Future<bool> notKnowPython(PythonNotKnowModel model) async{
    return await _notKnowToDatabase(model);
  }
  
  Future<bool> _notKnowToDatabase(PythonNotKnowModel model) async{
    final result = await backService.patch(
      DioPaths.setPythonData.name,
      data: {
        'username' : model.username,
        'isKnow' : model.isKnow
      }
    );
    return result.data['patchStatus'] == 1;
  }
  
  @override
  Future<PythonMachineModel?> controlPythonLevel(List<Map> data) async{
    final result = await backService.post(
      DioPaths.pythonMachine.name,
      data: {
        'result' : data
      }
    );
    if (result.data['status'] == 1) {
      PythonMachineModel model = PythonMachineModel(
        status: result.data['data']['status'] == 'passed' ? PythonMachineItems.passed : PythonMachineItems.failed
      );
      if (model.status == PythonMachineItems.failed) {
        model.recommendResult = result.data['data']['recommended_result'];
      }
      return model;
    }
    return null;
  }
  
  @override
  Future<bool> setPythonLevel(PythonKnowModel model) async{
    final result = await backService.patch(
      DioPaths.setPythonData.name,
      data: {
        'username' : model.username,
        'isKnow' : model.isKnow,
        'level' : model.status
      }
    );
    return result.data['patchStatus'] == 1;
  }
}
