import 'dart:convert';

import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/options_pages/user_nots/model/not_content_model.dart';
import 'package:codingo/views/options_pages/user_nots/model/nots_model.dart';


abstract class IUserNotsService {
  Future<List<NotsModel>> getNotsList(String username);
}

class UserNotsService with ProjectDio implements IUserNotsService {
  Future<List?> _getNotsListFromDatabase(String username) async{
    final result = await backService.get(
      DioPaths.getNots.name,
      queryParameters: {
        "username" : username,
      }
    );
    return result.data['status'] == 1 ? result.data['result'] : null;
  }

  @override
  Future<List<NotsModel>> getNotsList(String username) async{
    final list =  await _getNotsListFromDatabase(username);
    if (list != null) {
      return _tidyList(list);
    }
    return [];
  }
  
  List<NotsModel> _tidyList(List datas) {

     return datas.map((data) {
      List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(jsonDecode(data['Content']));
      List<NotContentModel> notsList = jsonList.map((json) => NotContentModel(content: json['content'])).toList();
      return NotsModel(
        contentList: notsList,
        lessonName: int.parse(data['Date'].toString().split('-')[0]) == 1 ? 'Matematik' : 'Python',
        lessonNumber: int.parse(data['Date'].toString().split('-')[1]) + 1,
      );
     }).toList();
  }
  
}