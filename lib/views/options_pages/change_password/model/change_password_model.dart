class ChangePasswordModel {
  late final String _name;
  late final String _newPassword;

  ChangePasswordModel(
    { 
      required String name,
      required String newPassword,
    }
    ){
      _name = name;
      _newPassword = newPassword;
    }
  
  String get getName => _name;
  String get getNewPassword => _newPassword;

}