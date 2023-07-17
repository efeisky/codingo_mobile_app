import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
abstract class IResetPasswordService{
  Future<bool> resetPassword(String email, String password);
}

class ResetPasswordService with ProjectDio implements IResetPasswordService {
  @override
  Future<bool> resetPassword(String email, String password) async {
    if(email != ''){
      final response = await backService.put(
        DioPaths.resetPassword.name,
        data: {
          'email' : email,
          'requestPassword' : password
        }
      );
      return response.data['status'] == 'Succesfully' ? true : false;
    }
    return false;
  }
  

}