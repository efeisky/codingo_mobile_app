import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/views/options_pages/verify_mail/service/user_verify_email_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserVerifyEmail extends StatefulWidget {
  const UserVerifyEmail({ Key? key }) : super(key: key);

  @override
  State<UserVerifyEmail> createState() => _UserVerifyEmailState();
}

class _UserVerifyEmailState extends State<UserVerifyEmail> with NavigatorMixin{
  String _initialUsername = '';
  late final VerifyEmailService _emailService;
  final bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _emailService = VerifyEmailService();
  }

  Future<void> _sendVerificationCode() async{
    final secretKey = await _emailService.sendVerifyCode(_initialUsername);
    router.pushReplacementToPage(NavigatorRoutesPaths.verifyEmailCode, arguments: secretKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Codingo',
        changeableTitle: 'Mailimi Doğrula',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.userSettings,
        ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _hasError ? const Text(
              'Hata Oluştu',
              style: TextStyle(
                color: FontTheme.errorColor,
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.bfontSize,
                fontWeight: FontWeight.bold
              ),
            ) : const Text(
              'Kodu göndermek için düğmeye bas',
              style: TextStyle(
                color: FontTheme.lightNormalColor,
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.nbfontSize,
                fontWeight: FontTheme.rfontWeight
              ),
            ),
      
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      
            CustomButton(
              buttonText: 'Kodu Gönder', 
              foregroundColor: Colors.white, 
              backgroundColor: Colors.black, 
              borderRadius: BorderRadius.circular(5), 
              horizontalPadding: 40, 
              verticalPadding: 20, 
              fontSize: FontTheme.fontSize, 
              onPressed: () async{
                _sendVerificationCode();
                return true;
              },
            )
          ],
        ),
      ),
    );
  }
}