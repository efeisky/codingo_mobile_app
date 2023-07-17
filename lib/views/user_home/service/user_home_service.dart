import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/user_home/model/user_home_model.dart';

abstract class IUserHomeService {
  Future<UserHomeModel> getUserValues(String username);
}

class UserHomeService with ProjectDio implements IUserHomeService {

  Future<Map> _getDatasFromDatabase(String username) async{
    final result = await backService.get(
      DioPaths.getUserMainpage.name,
      queryParameters: {
        'username' : username
      }
    );
    if (result.data['userCompleted'] == 1) {
      return result.data['lessonDatas'];
    }
    else{
      return {};
    }
  }

  UserHomeModel _setDatasAsModel(String username, Map data) {
    return UserHomeModel(
      name: username, 
      userCompleted: true,
      userClass: int.parse(data['userClass']),
      mathSubject: data['mathSubject'],
      mathNumber: data['mathNumber'],
      pythonStatus: data['userPython'] != 'unknowed' ? true : false, 
      pythonSubject: data['pythonSubject'],
      pythonNumber: data['pythonNumber'],
    );
  }

  @override
  Future<UserHomeModel> getUserValues(String username) async{
    final dbValues = await _getDatasFromDatabase(username);
    if(dbValues != {}){
      return _setDatasAsModel(username, dbValues);
    }
    return UserHomeModel(
      name: '',
      userClass: 0,
      userCompleted: false, 
      mathSubject: '',
      mathNumber: 0, 
      pythonNumber: 0, 
      pythonStatus: false, 
      pythonSubject: ''
    );
  }
  
  
  
}