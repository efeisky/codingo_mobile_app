import 'package:codingo/product/cache/user_cache.dart';

class LogOutCacheController {
  final UserCacheController _userCacheController;

  LogOutCacheController(this._userCacheController);
  
  Future<bool> logout() async{
    return await _userCacheController.deleteUser();
  }
}