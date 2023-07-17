import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class UserListTileTheme{
  static const TextStyle errorStyle = TextStyle(
    fontFamily: FontTheme.fontFamily,
    color: Colors.black,
    fontSize: FontTheme.xlfontSize,
    fontWeight: FontTheme.rfontWeight
  );
  static const TextStyle titleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily,
    color: Colors.black,
    fontSize: FontTheme.bfontSize,
    fontWeight: FontTheme.rfontWeight
  );
  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily,
    color: Colors.black,
    fontSize: FontTheme.nbfontSize,
    fontWeight: FontTheme.rfontWeight
  );
  static const Color progressClor = Color.fromRGBO(92, 74, 203, 1);
}