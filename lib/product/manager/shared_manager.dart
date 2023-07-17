
import 'package:codingo/product/exceptions/shared_not_initilaze.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeys {
  isLogin
}

class SharedManager {
  
  SharedPreferences? preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  void _checkPreferences() {
    if(preferences == null) throw SharedNotInitilazeException();
  }

  Future<void> saveString(SharedKeys key,String value) async{
    _checkPreferences();
    await preferences?.setString(key.name, value);
  }

  Future<void> saveBool(SharedKeys key,bool value) async{
    _checkPreferences();
    await preferences?.setBool(key.name, value);
  }

  String? getString(SharedKeys key) {
    _checkPreferences();
    return preferences?.getString(key.name);
  }

  bool? getBool(SharedKeys key) {
    _checkPreferences();
    return preferences?.getBool(key.name);
  }

}