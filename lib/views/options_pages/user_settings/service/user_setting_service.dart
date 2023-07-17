import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/options_pages/user_settings/model/user_setting_model.dart';

abstract class IUserSettingService {
  Future<UserSettingModel?> getSetting(String username);
  Future<bool> setThemeChanges(String title,String content, String username);
}

class UserSettingService with ProjectDio implements IUserSettingService {
  Future<Map?> _getSettingValuesFromDb(String username) async{
    final result = await backService.get(
      DioPaths.getSetting.name,
      queryParameters: {
        'name' : username,
      }
    );
    return result.data['status'] == 1 ? result.data['result'] : null;
  }
  
  @override
  Future<UserSettingModel?> getSetting(String username) async{
    final dataValue =  await _getSettingValuesFromDb(username);
    if(dataValue != null){
      return _tidySettingValues(dataValue);
    }
    return null;
  }
  
  UserSettingModel _tidySettingValues(Map data) {
    return UserSettingModel(
      realname : data['rn'],
      username : data['un'],
      school : data['school'],
      pictureSrc : data['src'] == '/assest/img/userIcons/unknown.png' ? '' : data['src'],
      userScore : data['score'],
      userEducation : data['eduLevel'],
      userProvince : data['province'],
      isVerified : data['v'] == 1,
      phoneNumber : data['pn'],
      isPhoneVerified : data['pv'] == 1,
      biographyTitle : data['bt'],
      biographyContent : data['btc'],
    );
  }
  
  Future<bool> _setThemeChangesToDb(String title,String content, String username) async{
    final result = await backService.put(
      DioPaths.saveThemeChanges.name,
      data: {
        'name' : username,
        'biography' : {
          'biographyTitle' : title,
          'biographyContent' : content
        }
      }
    );

    return result.data['status'] == 1;
  }
  
  @override
  Future<bool> setThemeChanges(String title,String content, String username) async{
    return await _setThemeChangesToDb(title,content, username);
  }
  
}