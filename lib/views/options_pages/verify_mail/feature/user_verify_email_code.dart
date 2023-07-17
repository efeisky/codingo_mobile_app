import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/enum/verify_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/options_pages/verify_mail/service/user_verify_email_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserVerifyEmailCode extends StatefulWidget {
  const UserVerifyEmailCode({ Key? key }) : super(key: key);

  @override
  State<UserVerifyEmailCode> createState() => _UserVerifyEmailCodeState();
}

class _UserVerifyEmailCodeState extends State<UserVerifyEmailCode> with NavigatorMixin {
  String _initialUsername = '';
  late final VerifyEmailService _emailService;
  late final TextEditingController _controller;
  String? _secretKey;
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _emailService = VerifyEmailService();
    _controller = TextEditingController();
    ()async{
      await _initializeValues();
    }();
  }

  Future<void> _initializeValues() async {

    if (_secretKey == null) {
      Future.microtask(() {
        final modelArgs = ModalRoute.of(context)?.settings.arguments;
        if(modelArgs is String){
          setState((){
            _secretKey = modelArgs;
          });
        }
    });
  }
  }

  Future<void> _verifyCode() async{
    if(_secretKey == _controller.text){
      setState((){
        _hasError = false;
      });
      final response = await _emailService.verifyEmail(_initialUsername, VerifyEnums.Email);
      if(response){
        router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
      }else{
        router.pushReplacementToPage(NavigatorRoutesPaths.userSettings);
      }
      
    }else{
      setState((){
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Codingo',
        changeableTitle: 'Kodu Doğrula',
        ),
      body: Center(
        child: Column(
          children: [
            CustomTextField(
              controller: _controller, 
              hintText: 'Mail Kodu', 
              prefixIcon: const Icon(Icons.code_rounded), 
              hasSuffixIcon: false, 
              inputAction: TextInputAction.done, 
              autoFillHints: const [AutofillHints.oneTimeCode], 
              textInputType: TextInputType.text
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _hasError ? const Text(
              'Hata Oluştu',
              style: TextStyle(
                color: FontTheme.errorColor,
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.bfontSize,
                fontWeight: FontWeight.bold
              ),
            ) : const SizedBox.shrink(),
      
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
                _verifyCode();
                return true;
              },
            )
          ],
        ),
      ),
    );
  }
}