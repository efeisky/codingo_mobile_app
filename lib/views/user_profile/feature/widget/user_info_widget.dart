import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.imagePath, required this.username, required this.realname, required this.isSecurity});
  final String imagePath;
  final String username;
  final String realname;
  final bool isSecurity;
  @override
  Widget build(BuildContext context) {
    const spacer = Spacer(flex: 1);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: imagePath.isEmpty
                ? ImagePaths.unknown.toWidget()
                : ImageNetworkWidget(pictureSrc: imagePath),
          ),
        ),
        spacer,
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                realname,
                style: const TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontWeight: FontTheme.rfontWeight,
                  fontSize: FontTheme.bfontSize,
                  color: FontTheme.lightNormalColor,
                ),
              ),
              Text(
                '@$username',
                style: const TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontWeight: FontTheme.rfontWeight,
                  fontSize: FontTheme.nbfontSize,
                  color: FontTheme.greenColor,
                ),
              ),
            ],
          ),
        ),
        spacer,
        Expanded(
          flex: 2,
          child: isSecurity ? ImagePaths.security_done.toWidget() : ImagePaths.security_fail.toWidget(),
        ),
      ],
    );
  }
}