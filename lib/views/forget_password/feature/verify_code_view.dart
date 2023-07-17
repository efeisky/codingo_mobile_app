import 'dart:async';

import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/otp-widget/otp_number_field.dart';
import 'package:codingo/views/forget_password/utils/get_unique_key.dart';
import 'package:flutter/material.dart';

class VerifyResetCodeView extends StatefulWidget {
  const VerifyResetCodeView({Key? key, this.deviceKey, this.oneTimeCode, this.email}) : super(key: key);
  final String? deviceKey;
  final String? oneTimeCode;
  final String? email;
  @override
  State<VerifyResetCodeView> createState() => _VerifyResetCodeViewState();
}

class _VerifyResetCodeViewState extends State<VerifyResetCodeView> with NavigatorMixin {
  int _countdownSeconds = 300;
  Timer? _timer;

  String? _deviceKey;
  String ? _oneTimeCode;
  String ? _email;

  @override
  void initState() {
    super.initState();

    () async {
      await _initializeValues();
      await _controlDeviceKey();
       startTimer();
    }();
  }

  Future<void> _initializeValues() async {
    _deviceKey = widget.deviceKey;
    _oneTimeCode = widget.oneTimeCode;
    _email = widget.email;

    if (_deviceKey == null) {
      Future.microtask(() {
        final modelArgs = ModalRoute.of(context)?.settings.arguments;
        setState(() {
          _deviceKey = modelArgs is Map ? modelArgs['deviceKey'] : widget.deviceKey;
          _oneTimeCode = modelArgs is Map ? modelArgs['oneTimeCode'] : widget.oneTimeCode;
          _email = modelArgs is Map ? modelArgs['email'] : widget.email;
        });
      });
    }
  }

  Future<void> _controlDeviceKey() async{
    final selectedDeviceKey = await getDeviceUniqueId();

    if(_deviceKey != null && _deviceKey == selectedDeviceKey){
      return;
    }
    else{
      router.pushReplacementToPage(NavigatorRoutesPaths.login);
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdownSeconds == 0) {
          timer.cancel();
          router.pushReplacementToPage(NavigatorRoutesPaths.home);
        } else {
          _countdownSeconds--;
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Codingo',
        changeableTitle: 'Şifre Kodu Doğrula',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.05),
            child: OtpNumberField(
              code: _oneTimeCode ?? '',
              onVerified: () {
                router.pushReplacementToPage(NavigatorRoutesPaths.resetPass,arguments: {'email':_email});
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          RichText(
            text:  TextSpan(
              text: 'Şifreyi doğrulamak için ',
              style: const TextStyle(
                color: _ScreenTheme.textColor,
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.fontSize,
                fontWeight: FontTheme.rfontWeight,
              ),
              children: [
                TextSpan(
                  text: '${formatDuration(Duration(seconds: _countdownSeconds))} dakikan',
                  style: const TextStyle(
                    color: _ScreenTheme.timeCounterColor,
                    fontWeight: FontTheme.xfontWeight,
                    fontSize: FontTheme.nbfontSize
                  ),
                ),
                const TextSpan(
                  text: ' kaldı!',
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}

class _ScreenTheme{
  static const Color timeCounterColor = Color.fromRGBO(92, 74, 203, 1);
  static const Color textColor = Color.fromRGBO(23, 23, 23, 1);

}