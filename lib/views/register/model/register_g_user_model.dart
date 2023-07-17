class GoogleRegisterModel {
  late final String _email;
  late final String _username;
  late final String? _pictureSrc;

  GoogleRegisterModel({
    required String email,
    required String username,
    required String? pictureSrc,
  }
  ) {
      _email = email;
      _username = username;
      _pictureSrc = pictureSrc;
    }
  
  String get getEmail => _email;
  String get getUsername => _username;
  String get getPictureSrc => _pictureSrc ?? '';
}
