import 'package:flutter/material.dart';

class UserNotifier extends ChangeNotifier {
  String _username = '';
  
  void setUsername(String requestedUsername) {
    _username = requestedUsername;
    notifyListeners();
  }
  
  String get currentUsername => _username;
}