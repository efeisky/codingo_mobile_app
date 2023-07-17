import 'package:flutter/material.dart';

import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';
class DegressWidget extends StatelessWidget {
  const DegressWidget({super.key, required this.score, required this.like, this.school, required this.province, required this.eduLevel, this.levelOfSchool, required this.levelOfProvince, required this.lastTenDay});
  final int score;
  final int like;
  final String? school;
  final String province;
  final int eduLevel;
  final int? levelOfSchool;
  final int levelOfProvince;
  final int lastTenDay;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DegreesInfoWidget(text: '${score.toString()} puan',icon: ImagePaths.user_score.toWidget(height: 50),),
        _DegreesInfoWidget(text: '${like.toString()} beğeni',icon: ImagePaths.profile_like.toWidget(height: 50),),
        eduLevel != 13 
        ? _DegreesInfoWidget(text: '$school Okulunda $levelOfSchool. sırada',icon: ImagePaths.profile_school_chart.toWidget(height: 50),) 
        : _DegreesInfoWidget(text: 'Bu kişi okulu bitirmiş',icon: ImagePaths.profile_school_chart.toWidget(height: 50),),
        _DegreesInfoWidget(text: '${province[0].toUpperCase() + province.substring(1).toLowerCase()} İlinde $levelOfProvince. sırada',icon: ImagePaths.profile_province_chart.toWidget(height: 50),),
        _DegreesInfoWidget(text: 'Son 10 günde $lastTenDay puan',icon: ImagePaths.profile_activity_chart.toWidget(height: 50),),
      ],
    );
  }
}

class _DegreesInfoWidget extends StatelessWidget {
  const _DegreesInfoWidget({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily,
              fontWeight: FontTheme.rfontWeight,
              fontSize: FontTheme.fontSize,
              color: FontTheme.lightNormalColor,
            ),
          ),
        ),
      ],
    );
  }
}
