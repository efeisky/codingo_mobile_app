import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:flutter/material.dart';

import 'package:codingo/product/mixin/Navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';

class FollowWidget extends StatefulWidget {
  const FollowWidget({super.key, required this.followerCount, required this.followCount, required this.profileOwner, required this.username});
  final int followerCount;
  final int followCount;
  final bool profileOwner;
  final String username;
  @override
  State<FollowWidget> createState() => _FollowWidgetState();
}

class _FollowWidgetState extends State<FollowWidget> with NavigatorMixin{

  void _pushUserToPages(_FollowTypes type) {
    if (widget.profileOwner) {
      if (type == _FollowTypes.follower) {
        router.pushReplacementToPage(NavigatorRoutesPaths.userFollowers);
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.userFollow);
      }
    }else{
      if (type == _FollowTypes.follower) {
        router.pushReplacementToPage(NavigatorRoutesPaths.otherFollowers,arguments: widget.username);
      }
      else{
        router.pushReplacementToPage(NavigatorRoutesPaths.otherFollow,arguments: widget.username);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _FollowButton(
          type: _FollowTypes.followed,
          count: widget.followCount, 
          onTap: _pushUserToPages,
        ),
        _FollowButton(
          type: _FollowTypes.follower,
          count: widget.followerCount, 
          onTap: _pushUserToPages,
        )
      ],
    );
  }
}
enum _FollowTypes{
  follower,followed
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    Key? key,
    required this.type,
    required this.count, required this.onTap,
  }) : super(key: key);

  final _FollowTypes type;
  final int count;
  final void Function(_FollowTypes type) onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap(type);
      }, 
      child: RichText(
        text: TextSpan(
          text: count.toString(),
          style: const TextStyle(
            fontFamily: FontTheme.fontFamily,
            fontWeight: FontTheme.xfontWeight,
            fontSize: FontTheme.bfontSize,
            color: FontTheme.lightNormalColor,
          ),
          children:  [
            TextSpan(
              text: type == _FollowTypes.follower ? ' Takipçi' : ' Takip',
              style: const TextStyle(
                fontFamily: FontTheme.fontFamily,
                fontWeight: FontTheme.rfontWeight,
                fontSize: FontTheme.nbfontSize,
                color: FontTheme.lightNormalColor,
              ),
            ),
          ],
        ),
      )
    );
  }
}
