import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/options_pages/user_settings/feature/enum/user_enum.dart';
import 'package:codingo/views/options_pages/user_settings/model/user_setting_model.dart';
import 'package:flutter/material.dart';

class UserVerifyWidget extends StatefulWidget {
  const UserVerifyWidget({super.key, required this.infoHeader, required this.settingModel, required this.onTap});
  final String infoHeader;
  final UserSettingModel settingModel;
  final void Function(UserVerifyType verifyType) onTap;

  @override
  State<UserVerifyWidget> createState() => _UserVerifyWidgetState();
}

class _UserVerifyWidgetState extends State<UserVerifyWidget> {
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
                _infoRowButton('Hesap Doğruluğu',model.isVerified, UserVerifyType.account ),
                _infoRowText('Telefon Numarası',model.phoneNumber),
                _infoRowButton('Telefon Doğruluğu', model.isPhoneVerified, UserVerifyType.phone),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _infoRowButton(String subject, bool status, UserVerifyType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _infoSubjectText(subject),
          _InfoTheme.sizedRowBox,
          _infoContentButton(status, type),
        ],
      ),
    );
  }

  Padding _infoRowText(String subject, String content) {
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
            content == '' ? 'Kapsam Dışı' : content,
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

  Row _infoContentButton(bool status, UserVerifyType type) {
    return Row(
      children: [
        status ? ImagePaths.security_done.toWidget(height: 32) : ImagePaths.security_fail.toWidget(height: 32),
        _InfoTheme.sizedRowBox,
        !status ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: _InfoTheme.verifyColor,
            shape: const StadiumBorder()
          ),
          onPressed: () {
            widget.onTap(type);
          },
          child: const Text(
            'Doğrula',
            style: TextStyle(
              fontFamily: FontTheme.fontFamily,
            ),
          ),
        ) : const SizedBox.shrink(),
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
  static const Color verifyColor = Color(0xFFEA4335);
  static const Color contentColor = Colors.black;
}