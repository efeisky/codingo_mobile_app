import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkWidget extends StatelessWidget {
  const ImageNetworkWidget({super.key, required this.pictureSrc});
  final String pictureSrc;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: pictureSrc,
      fit: BoxFit.cover,
       progressIndicatorBuilder: (context, url, downloadProgress) => 
               CircularProgressIndicator(
                value: downloadProgress.progress,
                color: _WidgetErrorColor.progressColor,
              ),
       errorWidget: (context, url, error) => const Icon(
        Icons.error, 
        color: _WidgetErrorColor.errorColor,
      ),
    );
  }
}
class _WidgetErrorColor {
  static const Color errorColor = Color.fromRGBO(234, 67, 53, 1);
  static const Color progressColor = Color.fromRGBO(90, 90, 90, 1);
}