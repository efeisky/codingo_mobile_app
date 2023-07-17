import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';
import 'package:codingo/views/register/model/register_user_model.dart';
import 'package:codingo/views/register/utils/format_username.dart';


abstract class IRegisterService {

  Future<Map> registerUser(String name,String email, String password, String eduLevel, String province, String school,SignTypeEnums signType);
}

class RegisterService with ProjectDio implements IRegisterService {

  final UserCacheController _userCacheController;

  RegisterService(this._userCacheController);

  @override
  Future<Map> registerUser(String name,String email, String password, String eduLevel, String province, String school,SignTypeEnums signType) async {
    RegisterModel registerModel = _createRegisterModel(name, email, password, eduLevel, province, school);
    return await _registerToDatabase(registerModel,signType);
  }


  _createRegisterModel(String name,String email, String password, String eduLevel, String province, String school) {
    return RegisterModel(
      name: name, 
      email: email, 
      password: password, 
      eduLevel: eduLevel, 
      province: province, 
      school: school
    );
  }
  
  Future<Map> _registerToDatabase(RegisterModel model, SignTypeEnums signType) async{
    final result = await backService.post(
      DioPaths.registerUser.name,
      data: {
        'username' : model.getName,
        'email' : model.getEmail,
        'password' : model.getPassword,
        'school' : model.getSchool,
        'userEducation' : model.getEdu == 'Mezun' ? '13' : model.getEdu,
        'userPython' : model.getPython,
        'userProvince' : model.getProvince,
        'signType' : signType.name
      }
    );
    if(result.data["status"] == 1){
      final username = formattedUsername(model.getName);
      await _userCacheController.saveUser(username);
      return {
        "status" : true
      };
    }
    return {
      "status" : false,
      "errorMsg" : result.data["errorID"] == 2 ? 'Bu kullanıcı adı dolu !' : 'Sistemsel bir hata meydana geldi !'
    };
  }
  
  
  
}