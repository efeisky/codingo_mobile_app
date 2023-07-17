class LoginModel {
  late final String _email;
  late final String _password;

  LoginModel(
    { 
      required String email,
      required String password,
    }
    ){
      _email = email;
      _password = password;
    }
  
  String get getEmail => _email;
  String get getPassword => _password;
}

class GoogleLoginModel {
  late final String _email;

  GoogleLoginModel(
    { 
      required String email,
    }
    ){
      _email = email;
    }
  
  String get getEmail => _email;
}