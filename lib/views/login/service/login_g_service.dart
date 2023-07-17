import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/login/model/login_model.dart';
import 'package:codingo/views/login/model/response_model.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';

abstract class ILoginByGoogleService {
  Future<bool> createLoginModel(String email);
}

class LoginByGoogleService with ProjectDio implements ILoginByGoogleService {
  final UserCacheController _userCacheController;

  LoginByGoogleService(this._userCacheController);

  Future<bool> _checkUserInDatabase(model, signType) async{
    final result = await backService.get(
      DioPaths.loginUser.name,
      queryParameters: {
        'signType' : signType.name,
        'email' : model.getEmail
      }
    );
    
    ResponseData responseData = ResponseData.fromJson(result.data);
    if (responseData.availabilityStatus == 1) {
      final String username = responseData.content?[0].username ?? '';
      await _userCacheController.saveUser(username);
      return true;
    }
    return false;
  }

  @override
  Future<bool> createLoginModel(String email) async{
    GoogleLoginModel googleLoginModel = GoogleLoginModel(email: email);

    return await _checkUserInDatabase(googleLoginModel, SignTypeEnums.Google);
  }
  
}