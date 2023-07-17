import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/views/options_pages/user_follow/feature/theme/user_list_tile_theme.dart';
import 'package:codingo/views/options_pages/user_follow/model/follow_user_model.dart';
import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({
    Key? key,
    required this.device,
    required this.followUser, required this.onTap,
  }) : super(key: key);

  final Size device;
  final FollowUserModel followUser;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: device.height * .025),
      title: Text(followUser.realName),
      subtitle: Text(followUser.username),
      leading: followUser.pictureSrc == '' ? ImagePaths.unknown.toWidget() : ImageNetworkWidget(pictureSrc: followUser.pictureSrc),
      titleTextStyle: UserListTileTheme.titleStyle,
      subtitleTextStyle: UserListTileTheme.subtitleStyle,
      trailing: const Icon(Icons.chevron_right_rounded,size: 32,),
      onTap: () {
        onTap();
      },
    );
  }
}