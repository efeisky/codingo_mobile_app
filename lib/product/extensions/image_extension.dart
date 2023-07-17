import 'package:codingo/product/enum/image_enums.dart';
import 'package:flutter/material.dart';

extension ImagePathsExtension on ImagePaths {
  String path(){
    return 'assets/img/$name.png';
  }

  Widget toWidget({double height = 100}){
    return Image.asset(
      path(), 
      height: height
    );
  }

  Widget toFullWidthWidget(BuildContext context){
    return Image.asset(
      path(), 
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}