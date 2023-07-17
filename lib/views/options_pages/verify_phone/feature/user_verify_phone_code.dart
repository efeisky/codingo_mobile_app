import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/enum/verify_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/otp-widget/otp_number_field.dart';
import 'package:codingo/views/options_pages/verify_phone/service/user_verify_phone_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserVerifyPhoneCode extends StatefulWidget {
  const UserVerifyPhoneCode({ Key? key }) : super(key: key);

  @override
  State<UserVerifyPhoneCode> createState() => _UserVerifyPhoneCodeState();
}

class _UserVerifyPhoneCodeState extends State<UserVerifyPhoneCode> with NavigatorMixin {
  String _initialUsername = '';
  late final VerifyPhoneService _emailService;
  String? _secretKey;
  
  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _emailService = VerifyPhoneService();
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
    final response = await _emailService.verifyPhone(_initialUsername, VerifyEnums.Phone);
    if(response){
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }else{
      router.pushReplacementToPage(NavigatorRoutesPaths.userSettings);
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.05),
              child: OtpNumberField(
                code: _secretKey ?? '',
                onVerified: () {
                  router.pushReplacementToPage(NavigatorRoutesPaths.userSettings);
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}