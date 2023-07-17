import 'package:codingo/product/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';

class HiveManager {

  Future<UserModel?> getUser() async {
  try {
    final box = await Hive.openBox<UserModel>('account');
    return box.getAt(0);
  } catch (e) {
    return null;
  }
}

  Future<void> setUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>('account');
    await box.clear();

    await box.add(user);
  }

  Future<void> deleteUser() async {
    final box = await Hive.openBox<UserModel>('account');
    await box.clear();

  }
}