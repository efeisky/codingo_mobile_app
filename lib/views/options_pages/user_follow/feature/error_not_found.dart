import 'package:codingo/views/options_pages/user_follow/feature/theme/user_list_tile_theme.dart';
import 'package:flutter/material.dart';

class ErrorNotFound extends StatelessWidget {
  const ErrorNotFound({
    Key? key,
    required this.device, required this.text,
  }) : super(key: key);

  final Size device;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: 
          Column(
            children: [
              Icon(Icons.error_outline_rounded,size: device.width * .2,),
              SizedBox(height: device.height * .025,),
              Text(
                text,
                style: UserListTileTheme.errorStyle,
              ),
            ],
          )
        ),
      ],
    );
  }
}