import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/func/email_function.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/product/widgets/button/social_button.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';
import 'package:codingo/views/login/service/login_service.dart';
import 'package:codingo/views/login/utils/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'login_social.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with NavigatorMixin{
  late final TextEditingController _passwordController;
  late final TextEditingController _mailController;
  LoginService? _loginService;
  bool checkStatus = true;
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _mailController = TextEditingController();
  }

  bool _checkValue(String email, String password) {
    bool value = validateEmail(email) && password.isNotEmpty;
    setState(() {
      checkStatus =  value ? true : false;
    });
    return value;
  }

  Future<bool> _onClickedButton(BuildContext context) async{
    _loginService = LoginService(UserCacheController(Provider.of<UserNotifier>(context, listen: false)));
    bool checkResult = _checkValue(_mailController.text,_passwordController.text);
    if(checkResult){
      final responseService = await _loginService!.checkLogin(_mailController.text,_passwordController.text,SignTypeEnums.Email);
      if(responseService){
        router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
      }
      else{
        setState(() {
          checkStatus = false;
        });
      }
      return false;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Codingo',
        changeableTitle: 'Giriş Yap',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.home
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            sizedHalfWhiteSpace(context),
            Form(
              child: Column(
                children: [
                  CustomTextField(
                    controller: _mailController,
                    hintText: 'Mail Adresi',
                    prefixIcon: const Icon(Icons.mail),
                    hasSuffixIcon: false,
                    inputAction: TextInputAction.next,
                    autoFillHints: const [AutofillHints.email],
                    textInputType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock),
                    hasSuffixIcon: true,
                    inputAction: TextInputAction.done,
                    autoFillHints: const [AutofillHints.newPassword],
                    textInputType: TextInputType.visiblePassword,
                    beObsecure: true,
                  ),
                  checkStatus == false
                  ? Column(
                      children: [
                        const Text(
                          'Hatalı Giriş',
                          style: TextStyle(
                            fontSize: FontTheme.fontSize,
                            color: _LoginTheme.errorColor,
                            fontWeight: FontTheme.rfontWeight,
                          ),
                        ),
                        sizedHalfWhiteSpace(context),
                      ],
                    )
                  : const SizedBox.shrink(),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.075),
                    child: Row(
                      children: [
                        const Text('Şifreni Unuttuysan,',
                          style: TextStyle(
                            fontFamily: _LoginTheme.fontFamily,
                            fontSize: _LoginTheme.fontSize
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            router.pushReplacementToPage(NavigatorRoutesPaths.forgetPass);
                          },
                          child: const Text('Şifremi Unuttum',
                            style: TextStyle(
                              fontFamily: _LoginTheme.fontFamily,
                              fontWeight: _LoginTheme.fontWeight,
                              color: _LoginTheme.navigatedTextColor,
                              decoration: _LoginTheme.decoration,
                              fontSize: _LoginTheme.fontSize
                              
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _sizedWhiteSpace(context),
                  CustomButton(
                    buttonText: 'Girişi Tamamla', 
                    foregroundColor: _LoginTheme.buttonFgColor, 
                    backgroundColor: _LoginTheme.buttonBgColor, 
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                    verticalPadding: 25,
                    horizontalPadding: 40,
                    fontSize: FontTheme.bfontSize, 
                    onPressed: ()async{
                      return await _onClickedButton(context);
                    },
                  ),
                  sizedHalfWhiteSpace(context),
      
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.075),
                    child: const Text(
                      'Giriş yaparak, politikalarımızı ve kullanım koşullarımızı kabul etmiş olursunuz.',
                      style: TextStyle(
                        fontSize: FontTheme.xsfontSize,
                        fontFamily: FontTheme.fontFamily,
                        fontWeight: FontTheme.rfontWeight,
                        color: _LoginTheme.detailTextColor
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            _sizedWhiteSpace(context),
      
            const Text(
              'Diğer Yollar',
              style: TextStyle(
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.bfontSize,
                color: _LoginTheme.otherDetailTextColor
              ),
            ),
      
            _sizedWhiteSpace(context),
            
            _SocialAreaForLogin(router: router,)
      
          ],
        ),
      )
    );
    
  }

  SizedBox sizedHalfWhiteSpace(BuildContext context) {
    return SizedBox(
          height: MediaQuery.of(context).size.height*.025,
        );
  }

  SizedBox _sizedWhiteSpace(BuildContext context) {
    return SizedBox(
          height: MediaQuery.of(context).size.height*.05,
        );
  }

}


class _LoginTheme{
  static const String fontFamily = 'Inter';
  static const FontWeight fontWeight = FontWeight.w600;
  static const Color navigatedTextColor = Color.fromRGBO(50, 37, 131, 1);
  static const Color detailTextColor = Color.fromRGBO(122, 122, 122, 1);
  static const Color otherDetailTextColor = Color.fromRGBO(90, 90, 90, 1);
  static const Color buttonBgColor = Color.fromRGBO(92, 74, 203, 1);
  static const Color buttonFgColor = Color.fromRGBO(255,255,255, 1);
  static const TextDecoration decoration = TextDecoration.underline;
  static const double fontSize = 16;
  static const Color errorColor = Color.fromRGBO(234, 67, 53, 1);

}