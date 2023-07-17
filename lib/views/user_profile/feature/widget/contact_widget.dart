// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:flutter/material.dart';

import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({super.key, required this.onLiked, required this.onFollowed, required this.name});
  final Future<void> Function() onLiked;
  final Future<void> Function() onFollowed;
  final String name;
  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> with NavigatorMixin {

  bool _isLiking = false;
  bool _isFollowing = false;
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    var sizedBox = SizedBox(height: device.height * 0.01,);
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ContactAction(
          device: device.width,
          bgColor: _ContanctStyles.chatColor,
          text: 'Mesajlaşmaya Başla',
          icon: ImagePaths.chat.toWidget(height: 30), 
          onTap: () { 
            router.pushReplacementToPage(NavigatorRoutesPaths.messageAsUser,arguments: widget.name);
          },
        ),
        sizedBox,
        !_isLiking ? _ContactAction(
          device: device.width,
          bgColor: _ContanctStyles.likeColor,
          text: 'Profilini Beğen',
          icon: ImagePaths.like.toWidget(height: 30), 
          onTap: (){
            setState(() {
              _isLiking = true;
            });
            widget.onLiked();
          },
        ) : const SizedBox.shrink(),
        sizedBox,
        !_isFollowing ? _ContactAction(
          device: device.width,
          bgColor: _ContanctStyles.followColor,
          text: 'Takip Et',
          icon: ImagePaths.follow.toWidget(height: 30),  
          onTap: (){
            setState(() {
              _isFollowing = true;
            });
            widget.onFollowed();
          },
        ) : const SizedBox.shrink(),
        sizedBox,
        _ContactAction(
          device: device.width,
          bgColor: _ContanctStyles.reportColor,
          text: 'Şikayet Et',
          icon: ImagePaths.report.toWidget(height: 30), 
          onTap: () { 
            router.pushReplacementToPage(NavigatorRoutesPaths.reportProfile,arguments: widget.name);
          },
        ),
      ],
    );
  }
}

class _ContactAction extends StatelessWidget {
  const _ContactAction({
    Key? key,
    required this.device, required this.bgColor, required this.text, required this.icon, required this.onTap,
  }) : super(key: key);

  final double device;
  final Color bgColor;
  final String text;
  final Widget icon;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon,
          ),
          SizedBox(width: device * 0.05,),
          Text(
            text,
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily,
              fontWeight: FontTheme.rfontWeight,
              fontSize: FontTheme.fontSize,
              color: FontTheme.lightNormalColor,
            ),
          )
        ],
      ),
    );
  }
}

class _ContanctStyles {
  static const Color chatColor = Color(0xFF6C63FF);
  static const Color likeColor = Color(0xFFEA4335);
  static const Color followColor = Color(0xFFEAAF03);
  static const Color reportColor = Color(0xFF232323);
}