import 'package:codingo/product/manager/shared_manager.dart';

class LoginCacheController {
  final SharedManager sharedManager;

  LoginCacheController(this.sharedManager);
  
  bool checkLoginStatus() {
    final loginStatus = sharedManager.getBool(SharedKeys.isLogin);
    if (loginStatus != null && loginStatus == true) {
      return true;
    }
    return false;
  }

}