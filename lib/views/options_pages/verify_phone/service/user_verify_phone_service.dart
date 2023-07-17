import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/enum/verify_enums.dart';
import 'package:codingo/product/global/project_dio.dart';

abstract class IVerifyPhoneService {
  Future<void> sendVerifyCode(String phoneNumber);
  Future<bool> verifyPhone(String name,VerifyEnums type);

}

class VerifyPhoneService with ProjectDio implements IVerifyPhoneService{
  @override
  Future<void> sendVerifyCode(String phoneNumber) async {
  }

  
  @override
  Future<bool> verifyPhone(String name, VerifyEnums type) async{
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