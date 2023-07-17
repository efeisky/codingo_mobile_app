import 'dart:convert';
import 'package:codingo/product/enum/file_enums.dart';
import 'package:codingo/product/extensions/file_extension.dart';
import 'package:flutter/services.dart';

abstract class JsonModel {
  Future<Map<String, dynamic>?> readJsonFile(String path) async {
    try {
      var jsonString = await rootBundle.loadString(path);
      var jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      throw Exception('Hata oluştu: $e');
    }
  }
}

class ProvinceModel extends JsonModel {
  final String? name;
  final String? code;

  ProvinceModel({this.name, this.code});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      name: json['name'],
      code: json['code'],
    );
  }
  
  List<ProvinceModel> mapToList(Map<String, dynamic> data) {
    List<ProvinceModel> provinces = data.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;
      return ProvinceModel.fromJson({'name': value, 'code': key});
    }).toList();
    
    return provinces;
  }

  Future<List<ProvinceModel>> getProvinceList() async {
    var jsonData = await readJsonFile(FilePaths.province.path());
    final listData = mapToList(jsonData!);
    return listData;
  }
}

class SchoolModel extends JsonModel {
  final String? name;
  final String? code;

  SchoolModel({this.name, this.code});

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      name: json['name'],
      code: json['code'],
    );
  }
  
  List<SchoolModel> tidyListData(List<dynamic> data) {
    List<SchoolModel> schoolList = [];
    for (var e in data) { 
      schoolList.add(SchoolModel(name: e['OKULADI'], code: schoolList.length.toString()));
    }
    return schoolList;
  }
  List tidyData(Map data,String province, int eduLevel) {
    var provincedData = data[province][0] ;
    var eduStrValue = eduLevel <= 4 ? 'İlkokul' : eduLevel >= 5 && eduLevel <= 8  ? 'Ortaokul' : 'Lise' ;
    var schoolData = provincedData[eduStrValue];
    return schoolData;
  }
  Future<List<SchoolModel>> getSchoolList(String province, String eduLevel) async {
    var jsonData = await readJsonFile(FilePaths.school.path());
    final tidiedData = tidyData(jsonData!, province, int.parse(eduLevel));
    final listData = tidyListData(tidiedData);
    return listData;
  }
}
