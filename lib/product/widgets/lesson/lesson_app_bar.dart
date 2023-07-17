import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class LessonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LessonAppBar({
    super.key, required this.context, required this.barTitle,
  });
  final BuildContext context;
  final String barTitle;

  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(context).size.height*.1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kToolbarHeight * 1.25,
      title: Text(
        barTitle,
        style: const TextStyle(
          fontFamily: FontTheme.fontFamily,
          fontSize: FontTheme.lessonHeaderFontSize,
          color: FontTheme.lightNormalColor,
          fontWeight: FontTheme.xfontWeight
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
  
}