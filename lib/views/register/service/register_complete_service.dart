import 'dart:convert';
import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';
import 'package:codingo/views/register/model/register_user_model.dart';
import 'package:codingo/views/register/utils/format_username.dart';
import 'package:dio/dio.dart';


abstract class IRegisterCompleteService {

  Future<Map> completeRegister(String name, String password, String eduLevel, String province, String school,SignTypeEnums signType);
}

class RegisterCompleteService with ProjectDio implements IRegisterCompleteService {

  final UserCacheController _userCacheController;

  RegisterCompleteService(this._userCacheController);

  @override
  Future<Map> completeRegister(String name, String password, String eduLevel, String province, String school,SignTypeEnums signType) async {
    RegisterModel registerModel = _createRegisterCompleteModel(name, password, eduLevel, province, school);
    return await _registerToDatabase(registerModel,signType);
  }


  _createRegisterCompleteModel(String name, String password, String eduLevel, String province, String school) {
    return RegisterModel(
      name: name, 
      email: '', 
      password: password, 
      eduLevel: eduLevel, 
      province: province, 
      school: school
    );
  }
  
  Future<Map> _registerToDatabase(RegisterModel model, SignTypeEnums signType) async{
    Map<String, dynamic> values = {
      'password': model.getPassword,
      'school': model.getSchool,
      'userEducation': model.getEdu == 'Mezun' ? '13' : model.getEdu,
      'userPython': model.getPython,
      'userProvince': model.getProvince,
    };

    String valuesJson = jsonEncode(values);
    FormData formData = FormData.fromMap({
      'signType': 'Google',
      'values': valuesJson,
      'username': model.getName,
    });
    final result = await backService.put(
      DioPaths.completeRegister.name,
      data: formData
    );
    if(result.data["changedValues"] == true){
      final username = formattedUsername(model.getName);
      await _userCacheController.saveUser(username);
      return {
        "status" : true
      };
    }
    return {
      "status" : false,
      "errorMsg" : 'Sistemsel bir hata meydana geldi !'
    };
  }
  
  
  
}