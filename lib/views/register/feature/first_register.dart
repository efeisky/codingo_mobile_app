import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/func/email_function.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/register/feature/register_bottom_area.dart';
import 'package:codingo/views/register/feature/theme/register_theme.dart';
import 'package:codingo/views/register/utils/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/widgets/button/social_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';

part 'register_social.dart';
class FirstRegisterView extends StatefulWidget  {
  const FirstRegisterView({super.key});

  @override
  State<FirstRegisterView> createState() => _FirstRegisterViewState();
}

class _FirstRegisterViewState  extends State<FirstRegisterView> with NavigatorMixin{
  final int pageNo = 1;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _hasEmpty = false;
  bool _hasError = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Codingo',
        hasArrow: true,
        changeableTitle: 'Kayıt Ol',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _sizedBox25(context),
                  _SocialButtonAreaForRegister(router: router),
                  _sizedBox25(context),
                  _otherDetailText(),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Ad Soyad',
                    prefixIcon: const Icon(Icons.person),
                    hasSuffixIcon: false,
                    inputAction: TextInputAction.next,
                    autoFillHints: const [AutofillHints.name],
                    textInputType: TextInputType.name,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Mail Adresi',
                    prefixIcon: const Icon(Icons.mail),
                    hasSuffixIcon: false,
                    inputAction: TextInputAction.next,
                    autoFillHints: const [AutofillHints.email],
                    textInputType: TextInputType.emailAddress,
                  ),
                  _hasError ? const Text(
                    'Geçerli Mail Giriniz !',
                    style: TextStyle(
                      fontSize: FontTheme.nbfontSize,
                      color: RegisterTheme.errorColor,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ) : const SizedBox.shrink(),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock),
                    hasSuffixIcon: true,
                    beObsecure: true,
                    inputAction: TextInputAction.done,
                    autoFillHints: const [AutofillHints.password, AutofillHints.newPassword],
                    textInputType: TextInputType.visiblePassword,
                  ),
                  _hasEmpty ? const Text(
                    'Tüm Alanlar Doldurulmalıdır !',
                    style: TextStyle(
                      fontSize: FontTheme.nbfontSize,
                      color: RegisterTheme.errorColor,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ) : const SizedBox.shrink(),
                  
                ],
              ),
            ),
          ),
          BottomArea(
            buttonIcon: const Icon(Icons.chevron_right_rounded),
            currentPageNo: pageNo, 
            buttonText: 'Sonraki Sayfa',
            onTap: ()async{
              if(_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                setState(() {
                  _hasEmpty = false;
                });
                if(validateEmail(_emailController.text)){
                  setState(() {
                    _hasError = false;
                    router.pushReplacementToPage(NavigatorRoutesPaths.secondRegister,arguments: {
                      'name' : _nameController.text,
                      'email' : _emailController.text,
                      'password' : _passwordController.text
                    });
                  });
                }else{
                  setState(() {
                    _hasError = true;
                  });
                }
              }
              else{
                setState(() {
                  _hasEmpty = true;
                });
              }
            },
          ),
        ],
      ),

    );
  }

  Text _otherDetailText() {
    return const Text(
            'Ya da',
            style: TextStyle(
              fontFamily: FontTheme.fontFamily,
              fontSize: FontTheme.bfontSize,
              color: RegisterTheme.otherDetailTextColor
            ),
          );
  }

  SizedBox _sizedBox25(BuildContext context) => SizedBox(height: MediaQuery.of(context).size.height*.025,);
}

