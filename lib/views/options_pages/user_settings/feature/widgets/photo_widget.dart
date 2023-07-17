import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/options_pages/user_settings/feature/enum/image_enum.dart';
import 'package:flutter/material.dart';

class UserPhotoWidget extends StatefulWidget {
  const UserPhotoWidget({super.key, required this.pictureSrc, required this.onTap});
  final String pictureSrc;
  final void Function(PictureActionTypes type) onTap;
  @override
  State<UserPhotoWidget> createState() => _UserPhotoWidgetState();
}

class _UserPhotoWidgetState extends State<UserPhotoWidget> {
  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 25,);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (widget.pictureSrc != '') ImageNetworkWidget(pictureSrc: widget.pictureSrc) else ImagePaths.unknown.toWidget(),
        if(widget.pictureSrc != '')
          Column(
            children: [
              InkWell(
                onTap: () {
                  widget.onTap(PictureActionTypes.change);
                },
                child: _buttonText('Resmi Değiştir'),
              ),
              sizedBox,
              InkWell(
                onTap: () {
                  widget.onTap(PictureActionTypes.delete);
                },
                child: _buttonText('Resmi Sil'),
              )
            ],
          )
        else
          InkWell(
            onTap: () {
              widget.onTap(PictureActionTypes.add);
            },
            child: _buttonText('Resim Ekle'),
          )
      ],
    );
  }

  Text _buttonText(String text) =>  Text(
    text,
    style: const TextStyle(
      fontFamily: FontTheme.fontFamily,
      fontSize: FontTheme.nbfontSize,
      fontWeight: FontTheme.xfontWeight
    ),
  );
}