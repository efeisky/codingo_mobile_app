import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';
import 'package:codingo/views/register/model/register_g_user_model.dart';

abstract class IRegisterByGoogleService {
  Future<Map> createRegisterModel(String email, String username, String? pictureSrc);
}

class RegisterByGoogleService with ProjectDio implements IRegisterByGoogleService {
  Future<Map> _registerToDatabase(model, signType) async{
    final result = await backService.post(
      DioPaths.registerUser.name,
      data: {
        'signType' : signType.name,
        'username' : model.getUsername,
        'email' : model.getEmail,
        'pictureSrc' : model.getPictureSrc
      }
    );
    
    if(result.data["status"] == 1){
      return {
        "status" : true,
        "username" : model.getUsername
      };
    }
    return {
      "status" : false,
      "errorMsg" : 'Sistemsel bir hata meydana geldi, Elle kayıt deneyiniz !'
    };
  }

  @override
  Future<Map> createRegisterModel(String email, String username, String? pictureSrc) async{
    GoogleRegisterModel googleRegisterModel = GoogleRegisterModel(email: email, username: username, pictureSrc: pictureSrc);
    return await _registerToDatabase(googleRegisterModel, SignTypeEnums.Google);
  }
  
}