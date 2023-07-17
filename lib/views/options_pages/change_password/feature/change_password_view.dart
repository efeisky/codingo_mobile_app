import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/options_pages/change_password/security/security_values.dart';
import 'package:codingo/views/options_pages/change_password/service/change_password_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> with NavigatorMixin {
  String _initialUsername = '';
  late final TextEditingController _usernameController;
  late final TextEditingController _newPasswordController;
  late final ChangePasswordService _service;
  bool _hasError = false;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _newPasswordController = TextEditingController();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = ChangePasswordService();
  }

  void _changeError(bool status) {
    if (status != _hasError) {
      setState(() {
        _hasError = status;
      });
    }
  }
  void _changeErrorText(String text) {
    if (text != _errorText) {
      setState(() {
        _errorText = text;
      });
    }
  }
  Future<void> _changePassword() async{
    bool checkStatus = checkValues(_initialUsername,_usernameController.text, _newPasswordController.text);

    if (checkStatus) {
      _changeError(false);
      final serviceStatus = await _service.changePasswordProcess(_initialUsername, _newPasswordController.text);
      if(!serviceStatus){
        _changeErrorText('Sistemsel bir hata meydana geldi!! Yönlendiriliyorsunuz');
        Future.delayed(_ChangePasswordTheme._waitDuration);
      }
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }
    else{
      _changeError(true);
      _changeErrorText('Girdiğiniz değerleri kontrol ediniz!');
    }
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    var sizedBox = SizedBox(height: device.height * .05,);
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Şifremi Değiştir',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.menu,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: _usernameController, 
              hintText: 'Kullanıcı Adı', 
              prefixIcon: const Icon(Icons.person),
              hasSuffixIcon: false,
              inputAction: TextInputAction.next,
              autoFillHints: const [AutofillHints.username],
              textInputType: TextInputType.name,
            ),
            sizedBox,
            CustomTextField(
              controller: _newPasswordController, 
              hintText: 'Yeni Şifre', 
              prefixIcon: const Icon(Icons.lock),
              hasSuffixIcon: true,
              inputAction: TextInputAction.done,
              autoFillHints: const [AutofillHints.newPassword],
              textInputType: TextInputType.visiblePassword,
              beObsecure: true,
            ),
            sizedBox,
            _hasError 
            ? Text(
              _errorText,
              style: const TextStyle(
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.fontSize,
                fontWeight: FontTheme.xfontWeight,
                color: _ChangePasswordTheme._errorColor
              ),
              )
            : const SizedBox.shrink(),
            sizedBox,
            CustomButton(
              buttonText: 'Şifremi Değiştir', 
              foregroundColor: _ChangePasswordTheme.fgColor, 
              backgroundColor: _ChangePasswordTheme.bgColor,
              borderRadius: _ChangePasswordTheme.borderRadius, 
              horizontalPadding: _ChangePasswordTheme.hPadding, 
              verticalPadding: _ChangePasswordTheme.vPadding, 
              fontSize: FontTheme.nbfontSize, 
              onPressed: () async{
                _changePassword();
                return true;
              }
            ),
            sizedBox,
            Text(
              '*Bu işlem geri alınamaz sonuçlara neden olabilir.',
              textAlign: _ChangePasswordTheme.textAlign,
              style: _ChangePasswordTheme.textStyle,
            )
          ],
        ),
      ),
    );
  }
}

class _ChangePasswordTheme {
  static const Color bgColor = Colors.black;
  static const Color fgColor = Colors.white;
  static BorderRadius borderRadius = BorderRadius.circular(10);
  static const double hPadding = 20;
  static const double vPadding = 15;
  static const TextAlign textAlign = TextAlign.center;
  static TextStyle textStyle = const TextStyle(
    fontFamily: FontTheme.fontFamily,
    fontSize: FontTheme.xsfontSize,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontWeight: FontTheme.xfontWeight
  );
  static const Color _errorColor = Color.fromRGBO(234, 67, 53, 1);
  static const Duration _waitDuration = Duration(seconds: 2);
}