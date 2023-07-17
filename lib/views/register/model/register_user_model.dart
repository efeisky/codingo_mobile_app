class RegisterModel {
  late final String _name;
  late final String _email;
  late final String _password;
  late final String _eduLevel;
  late final String _province;
  late final String _school;
  final String _userPython;


  RegisterModel(
    {
      required String name,
      required String email,
      required String password,
      required String eduLevel,
      required String province,
      required String school,
    }) : _userPython = 'unknowed' {
      _name = name;
      _email = email;
      _password = password;
      _eduLevel = eduLevel;
      _province = province;
      _school = school;
    }
  
  String get getName => _name;
  String get getEmail => _email;
  String get getPassword => _password;
  String get getEdu => _eduLevel;
  String get getProvince => _province;
  String get getSchool => _school;
  String get getPython => _userPython;
}