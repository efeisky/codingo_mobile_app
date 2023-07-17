import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/manager/hive_manager.dart';
import 'package:codingo/product/manager/shared_manager.dart';
import 'package:codingo/product/model/user_model.dart';

class UserCacheController {
  final HiveManager _hiveManager = HiveManager();
  final SharedManager _sharedManager = SharedManager();
  final UserNotifier _notifier;

  UserCacheController(this._notifier);
  
  Future<void> getUserCache() async{
    final userCache = await _hiveManager.getUser();
    if(userCache != null){
      await saveToProvider(userCache);
    }
  }

  Future<bool> deleteUser() async{
    try{
      await _sharedManager.init();
      await _sharedManager.saveBool(SharedKeys.isLogin, false);
      await _hiveManager.deleteUser();
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<void> saveToProvider(UserModel user) async{
    _notifier.setUsername(user.name);
  }

  Future<void> saveUser(String username) async{
    await _sharedManager.init();
    await _sharedManager.saveBool(SharedKeys.isLogin, true);
    final user = UserModel(name: username);
    await _hiveManager.setUser(user);
    await saveToProvider(user);
  }
}