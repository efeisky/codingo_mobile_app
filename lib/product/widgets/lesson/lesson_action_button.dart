import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';

class LessonActionButton extends StatefulWidget {
  const LessonActionButton({
    Key? key,
    required this.text,
    required this.bgColor,
    required this.fgColor, required this.onTap,
  }) : super(key: key);
  final String text;
  final Color bgColor;
  final Color fgColor;
  final Future<void> Function() onTap;
  @override
  State<LessonActionButton> createState() => _LessonActionButtonState();
}

class _LessonActionButtonState extends State<LessonActionButton> {
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: device.width * .05, vertical: device.height * .025),
      child: CustomButton(
        buttonText: widget.text, 
        foregroundColor: widget.fgColor, 
        backgroundColor: widget.bgColor, 
        borderRadius: BorderRadius.circular(10), 
        horizontalPadding: 2.5,
        verticalPadding: 5,
        fontSize: FontTheme.actionfontSize,
        onPressed: () async{
          await widget.onTap();
          return true;
        }
      ),
    );
  }
}

class ActionButtonTheme {
  static const Color logoutBg = Color(0x3335B771);
  static const Color logoutFg = Color(0xFF34B670);
  
  static const Color addnoteBg = Color(0x336C63FF);
  static const Color addnoteFg = Color(0xFF6C63FF);
}