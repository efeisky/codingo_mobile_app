class UserSettingModel {
  final String realname;
  final String username;
  final String school;
  final String pictureSrc;
  final int userScore;
  final String userEducation;
  final String userProvince;
  final bool isVerified;
  final String phoneNumber;
  final bool isPhoneVerified;
  final String biographyTitle;
  final String biographyContent;

  UserSettingModel({
    required this.realname,
    required this.username,
    required this.school,
    required this.pictureSrc,
    required this.userScore,
    required this.userEducation,
    required this.userProvince,
    required this.isVerified,
    required this.phoneNumber,
    required this.isPhoneVerified,
    required this.biographyTitle,
    required this.biographyContent,
  });
}
