import 'dart:math';
import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
abstract class IForgetPasswordService{
  Future<Map> sendCodeProcess(String email);
}

class ForgetPasswordService with ProjectDio implements IForgetPasswordService {
  

  String _setRandomCode(int length) {
    const String chars = '0123456789';
    Random random = Random();
    String otp = '';

    for (int i = 0; i < length; i++) {
      otp += chars[random.nextInt(chars.length)];
    }

    return otp;
  }
  
  Future<bool> _sendCodeToEmail(String code, String email) async{
    final response = await backService.post(
      DioPaths.forgetPass.name,
      data: {
        'myOTP' : code,
        'email' : email,
      }
    );

    if (response.data['sentStatus'] == 1) {
      return true;
    }else{
      return false;
    }
  }
  
  @override
  Future<Map> sendCodeProcess(String email) async{
    String designatedCode = _setRandomCode(6);
    final result = await _sendCodeToEmail(designatedCode, email);
    return {
      'status' : result,
      'code' : designatedCode
    };
  }
  
}