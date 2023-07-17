import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/navigator_extension.dart';
import 'package:flutter/material.dart';

class NavigatorManager {
  NavigatorManager._();
  static NavigatorManager instance = NavigatorManager._();

  final GlobalKey<NavigatorState> _navigatorGlobalKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorGlobalKey => _navigatorGlobalKey;


  void pushReplacementToPage(NavigatorRoutesPaths route, {Object? arguments}) {
    _navigatorGlobalKey.currentState?.pushReplacementNamed(
      route.withParaf,
      arguments: arguments
    );
  }
}