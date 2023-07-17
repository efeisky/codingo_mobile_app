import 'package:dio/dio.dart';

mixin ProjectDio{
  final backService = Dio(BaseOptions(baseUrl: 'https://codingo-server.onrender.com/'));
}