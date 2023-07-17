import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/views/user_message/feature/message_pages/message_theme.dart';
import 'package:codingo/views/user_message/model/user_profile_model.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    Key? key,
    required this.context, required this.model, required this.router,
  }) : super(key: key);

  final BuildContext context;
  final UserProfileModel model;
  final NavigatorManager router;
  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(context).size.height*.1);
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    var sizedBox = SizedBox(width: device.width *.05,);
    return Container(
      decoration: const BoxDecoration(
        color: MessageTheme.appBgColor,
        borderRadius: MessageTheme.appRadius,
      ),
      padding: EdgeInsets.only(left: device.width *.05,right: device.width *.05,top: MessageTheme.topPadding,bottom: MessageTheme.bottomPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              router.pushReplacementToPage(NavigatorRoutesPaths.userMessage);
            }, 
            icon: const Icon(Icons.chevron_left_rounded,size: 32,)
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: MessageTheme.appRadius,
            ),
            child: model.picture == '/assest/img/userIcons/unknown.png'
                ? ImagePaths.unknown.toWidget(height: 60)
                : model.picture.isNotEmpty
                    ?  model.picture == 'school' ? null : ImageNetworkWidget(pictureSrc: model.picture) 
                    : ImagePaths.unknown.toWidget(height: 60) ,
          ),
          sizedBox,
          Expanded(
            child: Text(
              model.realname,
              style: MessageTheme.titleStyle,
            ),
          )
        ],
      )
    );
  }
}
