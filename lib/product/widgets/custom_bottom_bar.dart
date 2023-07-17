// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:codingo/product/mixin/Navigator_mixin.dart';
import 'package:flutter/material.dart';

import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    Key? key,
    required this.activePage,
  }) : super(key: key);
  final NavigatorRoutesPaths activePage;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>  with NavigatorMixin {
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: displayWidth * .025, vertical: displayWidth * .025),
        height: displayWidth * .2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: widget.activePage == NavigatorRoutesPaths.userHome ? ImagePaths.home_filled_icon.toWidget(height: 32) : ImagePaths.home_icon.toWidget(height: 32),
              onTap: () => widget.activePage == NavigatorRoutesPaths.userHome ? null : router.pushReplacementToPage(NavigatorRoutesPaths.userHome),
            ),
            InkWell(
              child: widget.activePage == NavigatorRoutesPaths.userMessage ? ImagePaths.message_filled_icon.toWidget(height: 32) : ImagePaths.message_icon.toWidget(height: 32),
              onTap: () => widget.activePage == NavigatorRoutesPaths.userMessage ? null : router.pushReplacementToPage(NavigatorRoutesPaths.userMessage),
            ),
            InkWell(
              child: widget.activePage == NavigatorRoutesPaths.userDiscover ? ImagePaths.search_filled_icon.toWidget(height: 32) : ImagePaths.search_icon.toWidget(height: 32),
              onTap: () => widget.activePage == NavigatorRoutesPaths.userDiscover ? null : router.pushReplacementToPage(NavigatorRoutesPaths.userDiscover),
            ),
            InkWell(
              child: widget.activePage == NavigatorRoutesPaths.userProfile ? ImagePaths.profile_filled_icon.toWidget(height: 32) : ImagePaths.profile_icon.toWidget(height: 32),
              onTap: () => widget.activePage == NavigatorRoutesPaths.userProfile ? null : router.pushReplacementToPage(NavigatorRoutesPaths.userProfile),
            ),
          ],
        ),
      );
  }
}
