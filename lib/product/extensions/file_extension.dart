import 'package:codingo/product/enum/file_enums.dart';

extension FilePathsExtension on FilePaths {
  String path(){
    return 'assets/json/$name.json';
  }
}