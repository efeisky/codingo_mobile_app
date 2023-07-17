import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/login/model/login_model.dart';
import 'package:codingo/views/login/model/response_model.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';


abstract class ILoginService {

  Future<bool> checkLogin(String email, String password,SignTypeEnums signType);
}

class LoginService with ProjectDio implements ILoginService {
  final UserCacheController _userCacheController;

  LoginService(this._userCacheController);

  @override
  Future<bool> checkLogin(String email, String password,SignTypeEnums signType) async {
    LoginModel loginUser = _createLoginModel(email, password);

    return await _checkUserInDatabase(loginUser,signType);
  }


  _createLoginModel(String email, String password) {
    return LoginModel(email: email, password: password);
  }
  
  Future<bool> _checkUserInDatabase(LoginModel model, SignTypeEnums signType) async{
    final result = await backService.get(
      DioPaths.loginUser.name,
      queryParameters: {
        'signType' : signType,
        'email' : model.getEmail,
        'password' : model.getPassword
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
  
  
  
}