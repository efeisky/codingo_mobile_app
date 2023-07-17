import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/options_pages/change_password/model/change_password_model.dart';

abstract class IChangePasswordService {
  Future<bool> changePasswordProcess(String lastPass, String newPass);
}

class ChangePasswordService with ProjectDio implements IChangePasswordService {
  @override
  Future<bool> changePasswordProcess(String name, String newPass) async{
    final model = _createModel(name, newPass);
    return await _saveToDatabase(model);
  }
  
  ChangePasswordModel _createModel(String name, String newPass) {
    
    return ChangePasswordModel(name: name, newPassword: newPass);
  }
  
  Future<bool> _saveToDatabase(ChangePasswordModel model) async{
    final result = await backService.put(
      DioPaths.changePassword.name,
      data: {
        'name' : model.getName,
        'password' : model.getNewPassword
      }
    );
    return result.data['saveStatus'] == 1 ? true : false;
  }
  
}