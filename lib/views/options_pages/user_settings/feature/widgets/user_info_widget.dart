import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/options_pages/user_settings/model/user_setting_model.dart';
import 'package:flutter/material.dart';

class UserSettingInfoWidget extends StatefulWidget {
  const UserSettingInfoWidget({super.key, required this.infoHeader, required this.settingModel});
  final String infoHeader;
  final UserSettingModel settingModel;
  @override
  State<UserSettingInfoWidget> createState() => _UserSettingInfoWidgetState();
}

class _UserSettingInfoWidgetState extends State<UserSettingInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    final model = widget.settingModel;
    var sizedBox = SizedBox(height: device.height * .02);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: device.width * .05, vertical: device.height *.025),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _headerText(),
            sizedBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('İsim', model.realname),
                _infoRow('Kullanıcı Adı', model.username),
                _infoRow('Puan', '${model.userScore} Puan'),
                _infoRow('Okul', model.school),
                _infoRow('Sınıf', model.userEducation == '13' ? 'Mezun' : '${model.userEducation}. Sınıf'),
                _infoRow('Şehir', model.userProvince),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _infoRow(String subject, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _infoSubjectText(subject),
          _InfoTheme.sizedRowBox,
          _infoContentText(content),
        ],
      ),
    );
  }

  Text _infoSubjectText(String subject) {
    return Text(
      subject,
      style: const TextStyle(
        fontFamily: FontTheme.fontFamily,
        fontSize: FontTheme.bfontSize,
        fontWeight: FontTheme.xfontWeight,
        color: _InfoTheme.infoColor
      ),
    );
  }

  Wrap _infoContentText(String content) {
    return Wrap(
      children: [
        Text(
          content,
          overflow: TextOverflow.clip,
          softWrap: true,
          style: const TextStyle(
            fontFamily: FontTheme.fontFamily,
            fontSize: FontTheme.bfontSize,
            fontWeight: FontTheme.rfontWeight,
            color: _InfoTheme.contentColor,
          ),
        ),
      ],
    );
  }


  Text _headerText() {
    return Text(
          widget.infoHeader,
          style: const TextStyle(
            fontFamily: FontTheme.fontFamily,
            fontSize: FontTheme.nbfontSize,
            fontWeight: FontTheme.xfontWeight
          ),
        );
  }
}
class _InfoTheme {
  static const sizedRowBox = SizedBox(width: 20);
  static const Color infoColor = Color(0xFF4285F4);
  static const Color contentColor = Colors.black;
}