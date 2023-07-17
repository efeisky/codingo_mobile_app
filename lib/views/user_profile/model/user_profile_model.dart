class UserProfileModel {
  late final String realname;
  late final String username;
  late final int score;
  late final int eduLevel;
  late final String pythonLevel;
  late final int mathLessonNo;
  late final int pythonLessonNo;
  late final String biographyTitle;
  late final String biographyContent;
  late final int likeCount;
  late final int orderInSchool;
  late final int orderInProvince;
  late final int lastTenDayScore;
  late final int follower;
  late final int followed;
  late final int security;
  late final String school;
  late final String province;
  late final String picture;

  UserProfileModel({
    required this.realname,
    required this.username,
    required this.score,
    required this.eduLevel,
    required this.pythonLevel,
    required this.mathLessonNo,
    required this.pythonLessonNo,
    required this.biographyTitle,
    required this.biographyContent,
    required this.likeCount,
    required this.orderInSchool,
    required this.orderInProvince,
    required this.lastTenDayScore,
    required this.follower,
    required this.followed,
    required this.security,
    required this.school,
    required this.province,
    required this.picture,
  });
}
