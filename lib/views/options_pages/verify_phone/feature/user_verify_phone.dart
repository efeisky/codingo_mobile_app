import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class UserVerifyPhone extends StatefulWidget {
  const UserVerifyPhone({ Key? key }) : super(key: key);

  @override
  State<UserVerifyPhone> createState() => _UserVerifyPhoneState();
}

class _UserVerifyPhoneState extends State<UserVerifyPhone> with NavigatorMixin{
  late final TextEditingController _phoneController;
  final bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '+90');
  }

  Future<void> _sendVerificationCode() async{
    _showAlert('Bu sistem şu anda hizmet dışıdır');
  }

  Future<dynamic> _showAlert(String text) {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title:  const Text('Sistem Hatası'),
          content:  Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                router.pushReplacementToPage(NavigatorRoutesPaths.menu);
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Codingo',
        changeableTitle: 'Telefonumu Doğrula',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.userSettings,
        ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomTextField(
              controller: _phoneController, 
              hintText: 'Telefon Numarası', 
              prefixIcon: const Icon(Icons.phone_rounded), 
              hasSuffixIcon: false, 
              inputAction: TextInputAction.done, 
              autoFillHints: const [AutofillHints.telephoneNumber], 
              textInputType: TextInputType.phone
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