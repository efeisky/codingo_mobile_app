import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/options_pages/user_follow/model/follow_user_model.dart';

abstract class IUserFollowService {

  Future<List<FollowUserModel>> getFollowersList(String username);
  Future<List<FollowUserModel>> getFollowList(String username);
}

enum FollowType{
  follower,followed
}

class UserFollowService with ProjectDio implements IUserFollowService {
  Future<List> _getUserFromDatabase(String username,FollowType type) async{
    final result = await backService.get(
      DioPaths.getFollowValues.name,
      queryParameters: {
        "username" : username,
        "type" : type.name
      }
    );
    if(result.data['status'] == 1){
      List profileList = result.data['followDatas'];
      return profileList;
    }
    else{
      return [];
    }
  }

  @override
  Future<List<FollowUserModel>> getFollowersList(String username) async{
    final dbValues = await _getUserFromDatabase(username,FollowType.follower);
    return _tidyDatabaseList(dbValues);
  }

  List<FollowUserModel> _tidyDatabaseList(List dbList) {
    return dbList.map((e) => FollowUserModel(
      username: e['username'],
      realName: e['realname'],
      pictureSrc: e['pictureSrc'] == "/assest/img/userIcons/unknown.png" ? '' : e['pictureSrc'],
    )).toList();
  }
  
  @override
  Future<List<FollowUserModel>> getFollowList(String username) async{
    final dbValues = await _getUserFromDatabase(username,FollowType.followed);
    return _tidyDatabaseList(dbValues);
  }
  
}