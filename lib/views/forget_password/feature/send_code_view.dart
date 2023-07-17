import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/func/email_function.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_icon_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/forget_password/service/forget_pass_service.dart';
import 'package:codingo/views/forget_password/utils/get_unique_key.dart';
import 'package:flutter/material.dart';

class SendForgetCodeView extends StatefulWidget {
  const SendForgetCodeView({super.key});

  @override
  State<SendForgetCodeView> createState() => _SendForgetCodeViewState();
}

class _SendForgetCodeViewState extends State<SendForgetCodeView> with NavigatorMixin{
  late final TextEditingController _controller;
  late final ForgetPasswordService _service;
  bool _checkStatus = true;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _service = ForgetPasswordService();
  }

  Future<void> _verifyCode() async{
      if (validateEmail(_controller.text)) {
        if(_checkStatus == false) setState(() {_checkStatus = true;});

        final result = await _service.sendCodeProcess(_controller.text);
        if (result['status']) {
          final key = await getDeviceUniqueId();
          router.pushReplacementToPage(NavigatorRoutesPaths.verifyCode, arguments: {
            'deviceKey' : key,
            'oneTimeCode' : result['code'],
            'email' : _controller.text
          });
        }
      }
      else{
        if(_checkStatus == true) setState(() {_checkStatus = false;});
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Codingo',
        changeableTitle: 'Şifremi Unuttum',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.login,
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          CustomTextField(
            controller: _controller,
            hintText: 'Mail Adresi',
            prefixIcon: const Icon(Icons.mail),
            hasSuffixIcon: false,
            inputAction: TextInputAction.done,
            autoFillHints: const [AutofillHints.email],
            textInputType: TextInputType.emailAddress,
          ),
          _checkStatus == false
          ? const Text(
                'Hatalı Giriş',
                style: TextStyle(
                  fontSize: FontTheme.fontSize,
                  color: Colors.red,
                  fontWeight: FontTheme.rfontWeight,
                ),
            )
          : const SizedBox.shrink(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          CustomIconButton(
            backgroundColor: Colors.black,
            buttonText: 'Onay Kodu Gönder',
            iconType: ImagePaths.send_icon.toWidget(height: 30),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            fontSize: FontTheme.fontSize,
            foregroundColor: Colors.white,
            horizontalPadding: 25,
            verticalPadding: 25,
            onPressed: () async {
              await _verifyCode();
              return true;
            },
          ),
        ],
      ),

    );
  }
}