import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:flutter/material.dart';

mixin NavigatorMixin<T extends StatefulWidget> on State<T>{
  NavigatorManager get router => NavigatorManager.instance;
}