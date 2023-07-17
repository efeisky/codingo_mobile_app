class RegisterUserModel {
  String? educationLevel;
  String? province;
  String? school;

  RegisterUserModel({
    this.educationLevel,
    this.province,
    this.school,
  });
}

enum CustomEduLevelEnums{
  // ignore: constant_identifier_names
  Mezun
}
