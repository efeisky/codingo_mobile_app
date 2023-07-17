import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/forget_password/service/reset_pass_service.dart';
import 'package:flutter/material.dart';

class ResetPassView extends StatefulWidget {
  const ResetPassView({super.key, this.email});
  final String? email;
  @override
  State<ResetPassView> createState() => _ResetPassViewState();
}

class _ResetPassViewState extends State<ResetPassView> with NavigatorMixin {
  String? _email;
  late final TextEditingController _controller;
  late final ResetPasswordService _service;
  bool _hasError = false;
  @override
  void initState() {
    super.initState();
     () async {
      _controller = TextEditingController();
      _service = ResetPasswordService();
      await _initializeValues();
    }();
  }
  Future<void> _initializeValues() async {
    _email = widget.email;

    if (_email == null) {
      Future.microtask(() {
        final modelArgs = ModalRoute.of(context)?.settings.arguments;
        setState(() {
          _email = modelArgs is Map ? modelArgs['email'] : widget.email;
        });
      });
    }
  }

  Future<void> _changePass() async{
    final response = await _service.resetPassword(_email ?? '', _controller.text);
    if(response){
      router.pushReplacementToPage(NavigatorRoutesPaths.login);
    }
    else{
      setState(() {
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
        changeableTitle: 'Şifre Sıfırlama',
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          CustomTextField(
            controller: _controller, 
            hintText: 'Yeni Şifre', 
            prefixIcon: const Icon(Icons.lock), 
            hasSuffixIcon: true, 
            inputAction: TextInputAction.done, 
            autoFillHints: const [AutofillHints.password, AutofillHints.newPassword], 
            textInputType: TextInputType.visiblePassword,
            beObsecure: true,
          ),
          _hasError ? const Text(
            'Hata Oluştu',
            style: TextStyle(
              color: _ResetTheme._errorColor,
              fontFamily: FontTheme.fontFamily,
              fontSize: FontTheme.bfontSize,
              fontWeight: FontWeight.bold
            ),
          ) : const SizedBox.shrink(),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

          CustomButton(
            buttonText: 'Şifreyi Kaydet', 
            foregroundColor: Colors.white, 
            backgroundColor: Colors.black, 
            borderRadius: BorderRadius.circular(5), 
            horizontalPadding: 40, 
            verticalPadding: 20, 
            fontSize: FontTheme.fontSize, 
            onPressed: () async{
              if(_controller.text.isNotEmpty){
                setState(() {
                  _hasError = false;
                });
                await _changePass();
              }
              else{
                setState(() {
                  _hasError = true;
                });
              }
              return true;
            },
          )
        ],
      ),
    );
  }
}
class _ResetTheme{
  static const Color _errorColor = Color.fromRGBO(234, 67, 53, 1);
}