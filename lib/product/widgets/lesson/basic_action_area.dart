import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/widgets/lesson/lesson_action_button.dart';
import 'package:flutter/material.dart';

class BasicActionArea extends StatelessWidget {
  const BasicActionArea({
    super.key, required this.router,
  });
  final NavigatorManager router;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            child: LessonActionButton(
              text: 'Dersten Çık', 
              bgColor: ActionButtonTheme.logoutBg, 
              fgColor: ActionButtonTheme.logoutFg, 
              onTap: () async{ 
                router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
              },
            ),
          ),
        ],
      ),
    );
  }
}

