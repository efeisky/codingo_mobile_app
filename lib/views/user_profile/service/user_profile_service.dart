import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/user_profile/model/user_profile_model.dart';

enum ActionType{
  like,follow
}

abstract class IUserProfileService {

  Future<UserProfileModel?> getProfileValues(String requestedName);
  Future<bool> setReport(String username, String reportedUsername, String reportContent);
  Future<Map> setAction(ActionType type, String username, String actionedUsername);
}

class UserProfileService with ProjectDio implements IUserProfileService {

  @override
  Future<UserProfileModel?> getProfileValues(String requestedName) async {
    if (requestedName.isNotEmpty) {
      final data = await _getFromDatabase(requestedName);
      if (data['status']) {
        final model = _createProfileModel(data['variables']);
        return model;
      }
      return null;
    }else{
      return null;
    }
    
  }

  UserProfileModel _createProfileModel(Map data) {
    return UserProfileModel(
      realname: data['realName'],
      username: data['username'],
      school: data['school'],
      province: data['province'],
      picture: data['picture'],
      score: data['score'],
      eduLevel: int.parse(data['eduLevel']),
      pythonLevel: data['pythonLevel'],
      mathLessonNo: data['mathLessonNo'],
      pythonLessonNo: data['pythonLessonNo'],
      biographyTitle: data['biographyTitle'],
      biographyContent: data['biographyContent'],
      likeCount: data['likeCount'],
      orderInSchool: data['orderInSchool'],
      orderInProvince: data['orderInProvince'],
      lastTenDayScore: data['lastTenDayScore'],
      follower: data['follower'],
      followed: data['followed'],
      security: data['security'],
    );
  }
  
  Future<Map> _getFromDatabase(String username) async{
    final result = await backService.get(
      DioPaths.profileByUsername.name,
      queryParameters: {
        'username' : username,
      }
    );
    if (result.data['processResult'] == 1) {
      return {
        'status' : true,
        'variables' : result.data['formattedData']
      };
    }
    else{
      return {
        'status' : false
      };
    }

  }
  
  Future<bool> _setReportToDatabase(String username, String reportedUsername, String reportContent) async{
    final result = await backService.post(
      DioPaths.sendReportProfile.name,
      data: {
        'utp' : reportedUsername,
        'upto' : username,
        'reportContent' : reportContent
      }
    );
    return result.data['sendStatus'] == 1;
  }
  
  @override
  Future<bool> setReport(String username, String reportedUsername, String reportContent) async{
    return await _setReportToDatabase(username, reportedUsername, reportContent);
  }
  
  @override
  Future<Map> setAction(ActionType type, String username, String actionedUsername) async{
    return await _setActionToDatabase(type, username, actionedUsername);
  }
  
  Future<Map> _setActionToDatabase(ActionType type, String username, String actionedUsername) async{
    final result = await backService.post(
      DioPaths.profileActions.name,
      data: {
        'transaction' : type.name,
        'utp' : actionedUsername,
        'upto' : username
      }
    );
    return {
      'status' : result.data['status'] == 1,
      'errorMessage' : result.data['status'] == 0 ? result.data['errorMsg'] : ''
    };
  }
  
}