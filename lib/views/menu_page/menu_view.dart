// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';

import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  NavigatorRoutesPaths? _backPage;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _backPage = args['backPage'];
    }
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Seçenekler',
        hasArrow: true,
        backPage: _backPage ?? NavigatorRoutesPaths.userHome,
      ),
      body:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuItem(content: 'Ayarlar',routerPath: NavigatorRoutesPaths.userSettings,),
          _MenuItem(content: 'Notlarım',routerPath: NavigatorRoutesPaths.userNots,),
          _MenuItem(content: 'Sıralamam',routerPath: NavigatorRoutesPaths.userOrder,),
          _MenuItem(content: 'QR Kodu Göster',routerPath: NavigatorRoutesPaths.userQr,),
          _MenuItem(content: 'Şifremi Değiştir',routerPath: NavigatorRoutesPaths.changePassword,),
          _MenuItem(content: 'Takipçilerim',routerPath: NavigatorRoutesPaths.userFollowers,),
          _MenuItem(content: 'Takip Ettiklerim',routerPath: NavigatorRoutesPaths.userFollow,),
          _MenuItem(content: 'Hesaptan Çık',routerPath: NavigatorRoutesPaths.logOut,),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({
    Key? key,
    required this.content, required this.routerPath,
  }) : super(key: key);

  final String content;
  final NavigatorRoutesPaths routerPath;

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> with NavigatorMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 50),
      child: InkWell(
        child: Text(
          widget.content,
          style: const TextStyle(
            fontFamily: FontTheme.fontFamily,
            fontWeight: FontTheme.rfontWeight,
            fontSize: FontTheme.bfontSize
          ),
        ),
        onTap: () {
          router.pushReplacementToPage(widget.routerPath);
        },
      ),
    );
  }
}
