import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class MessageTheme {
  static const Color appBgColor =  Color(0x194285F4);
  static const Color appBorderColor =  Color(0xFF4285F4);
  static const Color appFgColor =  Color(0xFF4285F4);
  static const double elevation =  0;
  static const double topPadding =  60;
  static const double bottomPadding =  15;
  static const BorderRadius appRadius = BorderRadius.vertical(bottom: Radius.circular(20));
  static const TextStyle titleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily,
    fontSize: FontTheme.xlfontSize,
    fontWeight: FontTheme.xfontWeight
  );
}