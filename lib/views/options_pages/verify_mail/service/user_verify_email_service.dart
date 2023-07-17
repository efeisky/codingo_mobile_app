import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/enum/verify_enums.dart';
import 'package:codingo/product/global/project_dio.dart';

abstract class IVerifyEmailService {
  Future<String?> sendVerifyCode(String email);
  Future<bool> verifyEmail(String name,VerifyEnums type);
}

class VerifyEmailService with ProjectDio implements IVerifyEmailService{
  @override
  Future<String?> sendVerifyCode(String username) async{
    final response = await backService.post(
      DioPaths.sendVerificationCode.name,
      data: {
        'name' : username,
      }
    );
    return response.data['status'] == 1 ? response.data['formattedKey'] : null;
  }
  
  @override
  Future<bool> verifyEmail(String name, VerifyEnums type) async{
    final response = await backService.put(
      DioPaths.setVerify.name,
      data: {
        'name' : name,
        'type' : type.name
      }
    );
    
    return response.data['status'] == 1;
  }
  
}