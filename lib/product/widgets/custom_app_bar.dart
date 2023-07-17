import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
    required this.context, 
    required this.mainTitle,
    this.changeableTitle, this.hasArrow, this.backPage, this.fontSize, this.hasMenu, this.onTap, this.fontColor
  });
  final BuildContext context;

  final String mainTitle;
  final String? changeableTitle;
  final bool? hasArrow;
  final bool? hasMenu;
  final void Function()? onTap;
  final NavigatorRoutesPaths? backPage;
  final double? fontSize;
  final Color? fontColor;
  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(context).size.height*.1);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _CustomAppBarTheme().bgColor,
      elevation: _CustomAppBarTheme().elevation,
      toolbarHeight: MediaQuery.of(context).size.height*.1,
      foregroundColor: fontColor ?? _CustomAppBarTheme().fgColor,
      actions: [
        hasMenu == true ? 
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*.075),
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.menu)
          ),
        )
        : const SizedBox.shrink()
      ],
      title: SizedBox(
        height: MediaQuery.of(context).size.height*.1,
        child: Column(
          crossAxisAlignment: _CustomAppBarTheme().crossAxisAlignment,
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 4,
              child: hasArrow == true
              ?
              Row(
                children: [
                  _ArrowButton(toPage: backPage),
                  SizedBox(width: _CustomAppBarTheme().whiteSpace,),
                  Text(
                    mainTitle,
                    style: TextStyle(
                      fontSize: fontSize ?? _CustomAppBarTheme().mTitleSize,
                      fontWeight: _CustomAppBarTheme().mTitleWeight,
                      fontFamily: _CustomAppBarTheme().fontFamily,
                      
                    ),
                  ),
                ],
              )
              :
              Text(
                mainTitle,
                style: TextStyle(
                  fontSize: fontSize ?? _CustomAppBarTheme().mTitleSize,
                  fontWeight: _CustomAppBarTheme().mTitleWeight,
                  fontFamily: _CustomAppBarTheme().fontFamily
                ),
              )
              
            ),
            const Spacer(flex: 2),
            Expanded(flex: 4,child: Text(
              changeableTitle ?? '',
              style: TextStyle(
                fontSize: _CustomAppBarTheme().cTitleSize,
                fontWeight: _CustomAppBarTheme().cTitleWeight,
                fontFamily: _CustomAppBarTheme().fontFamily
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  const _ArrowButton({
    Key? key, this.toPage
  }) : super(key: key);
  final NavigatorRoutesPaths? toPage;
  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> with NavigatorMixin {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.pushReplacementToPage(widget.toPage ?? NavigatorRoutesPaths.home);
      },
      child: ImagePaths.arrow_left.toWidget(),
    );
  }
}

class _CustomAppBarTheme {
  final Color bgColor = Colors.transparent;
  final Color fgColor = Colors.black;

  final double elevation = 0;
  final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;

  final double mTitleSize = 24;
  final double cTitleSize = 18;
  final FontWeight mTitleWeight = FontWeight.w600;
  final FontWeight cTitleWeight = FontWeight.w500;

  final String fontFamily = 'Inter';
  final double whiteSpace = 10;
}