import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/user_discover/model/profile_model.dart';


abstract class IDiscoverService {

  Future<List<ProfileModel>> getProfileList();
}

class DiscoverService with ProjectDio implements IDiscoverService {

  @override
  Future<List<ProfileModel>> getProfileList() async {
    final dbValues = await _getProfilesFromDatabase();
    return _tidyDatabaseList(dbValues);
    
  }

  Future<List> _getProfilesFromDatabase() async{
    final result = await backService.get(
      DioPaths.searchProfile.name
    );
    List profileList = result.data['profile'];
    return profileList;
  }
  
  List<ProfileModel> _tidyDatabaseList(List dbList) {
    return dbList.map((e) => ProfileModel(
      username: e['username'],
      realName: e['realName'],
      pictureSrc: e['pictureSrc'],
    )).toList();
  }
  
}