import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  const SocialButton({
    super.key, 
    required this.socialType, 
    required this.onTap,
  });
  final ImagePaths socialType;
  final Future<bool> Function() onTap;

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width*.2,
        height: MediaQuery.of(context).size.width*.2,
        decoration: BoxDecoration(
          border: Border.all(
            color: _SocialButton.socialBorderColor,
            width: _SocialButton.borderThickness,
          ),
          borderRadius: _SocialButton.socialBorderRadius,
        ),
        child: widget.socialType.toWidget(),
      ),
    );
  }
}

class _SocialButton {
  static const Color socialBorderColor = Color.fromRGBO(202, 202, 202, 1);
  static const double borderThickness = 1;
  static const BorderRadius socialBorderRadius = BorderRadius.all(Radius.circular(10));
  
}