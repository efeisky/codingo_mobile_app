
import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  const CustomSearchField({super.key, required this.controller, required this.hintText, required this.prefixIcon,
   required this.hasSuffixIcon, required this.inputAction, required this.autoFillHints, required this.textInputType,
   this.beObsecure = false, this.onChange,});
  final TextEditingController controller;
  final Widget prefixIcon;
  final bool hasSuffixIcon;
  final String hintText;
  final TextInputAction inputAction;
  final Iterable<String> autoFillHints;
  final TextInputType textInputType;
  final bool beObsecure;
  final void Function(String)? onChange;

  @override
  State<CustomSearchField> createState() => _CustomSearchField();
}

class _CustomSearchField extends State<CustomSearchField> {
  bool _isSecure = true;
  void _changeVisibility() {
    setState(() {
      _isSecure = !_isSecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * _PasswordFieldTheme.paddingHorizontal , vertical: _PasswordFieldTheme.paddingVertical),
            child: TextField(
              controller: widget.controller,
              autofillHints:  widget.autoFillHints,
              keyboardType: widget.textInputType,
              textInputAction: widget.inputAction,
              cursorColor: _PasswordFieldTheme.cursorColor,
              style: const TextStyle(
                color:  _PasswordFieldTheme.textColor,
                fontSize: _PasswordFieldTheme.textSize,
                fontFamily: _PasswordFieldTheme.fontFamily,
                fontWeight: _PasswordFieldTheme.fontWeight
              ),
              obscureText: widget.beObsecure ? _isSecure : false,
              decoration:   InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: _PasswordFieldTheme.borderRadius
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: _PasswordFieldTheme.borderColor), 
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: _PasswordFieldTheme.focusBorderColor), 
                ),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: _PasswordFieldTheme.hintColor
                ),
                prefixIconColor: _PasswordFieldTheme.iconColor,
                suffixIconColor: _PasswordFieldTheme.iconColor,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.hasSuffixIcon ? _onVisibilityIcon() : null,
              ),
              onChanged: widget.onChange,
      ),
    );
    
  }

  IconButton _onVisibilityIcon() {
    return IconButton(
      splashColor: Colors.transparent,
      onPressed: (){
        _changeVisibility();
      }, 
      icon: Icon(_isSecure ? Icons.visibility: Icons.visibility_off)
    );
  }
}

class _PasswordFieldTheme{
  static const Color borderColor = Color.fromRGBO(242, 242, 242, 1);
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(5));
  static const Color focusBorderColor = Color.fromRGBO(204, 204, 204, 1);

  static const Color iconColor = Color.fromRGBO(192, 192, 192, 1);
  static const Color cursorColor = Color.fromRGBO(150, 150, 150, 1);
  static const Color hintColor = Color.fromRGBO(168, 168, 168, 1);

  static const Color textColor = Color.fromRGBO(24, 24, 24, 1);
  static const double textSize = 16;
  static const String fontFamily = 'Inter';
  static const FontWeight fontWeight = FontWeight.w500;

  static const double paddingVertical = 15;
  static const double paddingHorizontal = .1;
}