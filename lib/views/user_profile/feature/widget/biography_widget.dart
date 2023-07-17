import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class BiographyWidget extends StatelessWidget {
  const BiographyWidget({super.key, required this.biographyTitle, required this.biographyContent});
  final String biographyTitle;
  final String biographyContent;
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context).size;
    const sizedBox = SizedBox(height: 10,);
    return SizedBox(
      width: device.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            biographyTitle,
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily,
              fontWeight: FontTheme.xfontWeight,
              fontSize: FontTheme.xlfontSize,
              color: FontTheme.lightNormalColor,
            ),
          ),
          sizedBox,
          Text(
            biographyContent,
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily,
              fontWeight: FontTheme.rfontWeight,
              fontSize: FontTheme.fontSize,
              color: FontTheme.lightNormalColor,
            ),
          ),
        ],
      ),
    );
  }
}