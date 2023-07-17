import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpNumberField extends StatefulWidget {
  const OtpNumberField({super.key, required this.code, required this.onVerified});
  final String code;
  final void Function() onVerified;
  @override
  State<OtpNumberField> createState() => _OtpNumberFieldState();
}

class _OtpNumberFieldState extends State<OtpNumberField> {
  bool _hasError = false;
  final TextEditingController _controller = TextEditingController();
  void _checkCode(String value) {
    if(widget.code == value){
      setState(() {
        _hasError = false;
      });
      widget.onVerified();
    }
    else{
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PinCodeTextField(
          appContext: context, 
          length: 6,
          controller: _controller,
          keyboardType: TextInputType.number,
          onCompleted: (value) {
            _checkCode(value);
            _controller.clear();
          },
          animationType: AnimationType.slide,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            activeColor: _hasError ? _PinCodeTheme._errorColor: _PinCodeTheme._activeColor, 
            inactiveColor: _PinCodeTheme._inactiveAndDisabledColor,
            disabledColor: _PinCodeTheme._inactiveAndDisabledColor,
            selectedColor: _PinCodeTheme._selectedColor,
            fieldHeight: 50,
            fieldWidth: 40,
          ),
          hapticFeedbackTypes: HapticFeedbackTypes.vibrate,
          ),
          _hasError ? const Text(
            'Hatalı Kod',
            style: TextStyle(
              color: _PinCodeTheme._errorColor,
              fontFamily: FontTheme.fontFamily,
              fontSize: FontTheme.bfontSize,
              fontWeight: FontWeight.bold
            ),
          ) : const SizedBox.shrink()
      ],
    );
  }
}

class _PinCodeTheme {
  static const Color _activeColor = Color.fromRGBO(192, 192, 192, 1);
  static const Color _inactiveAndDisabledColor = Color.fromRGBO(204, 204, 204, 1);
  static const Color _selectedColor = Color.fromRGBO(150, 150, 150, 1);
  static const Color _errorColor = Color.fromRGBO(234, 67, 53, 1);
}