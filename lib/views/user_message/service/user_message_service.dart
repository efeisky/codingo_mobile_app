import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/user_message/model/message_model.dart';
import 'package:codingo/views/user_message/model/user_message_model.dart';
import 'package:codingo/views/user_message/model/user_profile_model.dart';
import 'package:codingo/views/user_message/util/date_util.dart';

enum MessageMode {
  personel, school
}
abstract class IMessageService {

  Future<List<UserMessageModel>?> getMessageList(String username);
  Future<String?> getSchoolName(String username);
  Future<bool> sendMessage(String message, String senderName, String receiverName, MessageMode mode);
  Future<UserProfileModel> getUserProfileData(String username);
  Future<List<MessageModel>?> getUserMessageData(String username,String messageUsername);
  Future<List<MessageModel>?> getSchoolMessageData(String username,String schoolName);
}

class MessageService with ProjectDio implements IMessageService {

  @override
  Future<List<UserMessageModel>?> getMessageList(String username) async {
    final userToUserData =  await _getUtoUMessageListFromDatabase(username);
    if (userToUserData != null) {
      final dataList = _setDataAsModel(userToUserData);
      return dataList;
    }
    return null;
  }

  @override
  Future<String?> getSchoolName(String username) async{
    final schoolName =  await _getSchoolMessageListFromDatabase(username);
    return schoolName;
  }

  Future<List?> _getUtoUMessageListFromDatabase(String username) async{
    final result = await backService.get(
      DioPaths.chatUserList.name,
      queryParameters: {
        'username' : username
      }
    );
    return result.data['status'] == 1 ? result.data['data'] : null;
  }
  
  Future<String?> _getSchoolMessageListFromDatabase(String username) async{
    final result = await backService.get(
      DioPaths.getSchoolForChat.name,
      queryParameters: {
        'username' : username
      }
    );
    return result.data['status'] == 1 ? result.data['name'] : null;
  }
  
  List<UserMessageModel> _setDataAsModel(List data) {
    return data.map((data) {
      return UserMessageModel(
        username: data['username'],
        picture: data['picture'],
        lastContent: data['lastContent'],
        lastChatTime: DateTime.parse(data['lastChatTime']),
        lastMessageSentByUser: data['lastMessageSentByUser'],
        isRead: data['isRead'] == 1,
      );
    }).toList();
  }
  
  @override
  Future<UserProfileModel> getUserProfileData(String username) async{
    return await _getProfileDataFromDatabase(username);
  }
  
  Future<UserProfileModel> _getProfileDataFromDatabase(String username) async{

    final result = await backService.get(
      DioPaths.userDetailForChat.name,
      queryParameters: {
        'username' : username
      }
    );
    return UserProfileModel(
      username: username,
      realname: result.data['realName'],
      picture: result.data['pictureSrc'],
    );
  }
  
  Future<List?> _getUserMessageDataFromDatabase(String username, String messageUsername) async{
    final result = await backService.get(
      DioPaths.messageListByChat.name,
      queryParameters: {
        'nowUsername' : username,
        'toUsername' : messageUsername
      }
    );
    
    return result.data['status'] == 1 ? result.data['data'] : null;
  }
  
  @override
  Future<List<MessageModel>?> getUserMessageData(String username, String messageUsername) async {
    final data = await _getUserMessageDataFromDatabase(username, messageUsername);
    if (data != null) {
      return _setDataAsMessage(data);
    }
    return null; 
  }
  
  List<MessageModel> _setDataAsMessage(List datas) {
    return datas.map((data) {
      return MessageModel(
        content : data['content'],
        date : DateTime.parse(data['date']),
        messageSender : data['isUserSentMessage'] == 1
      );
    }).toList();
  }
  
  Future<List?> _getSchoolMessageDataFromDatabase(String username, String schoolName) async{
    final result = await backService.get(
      DioPaths.messageListBySchoolChat.name,
      queryParameters: {
        'username' : username,
        'name' : schoolName
      }
    );
    return result.data['status'] == 1 ? result.data['data'] : null;
  }
  
  @override
  Future<List<MessageModel>?> getSchoolMessageData(String username, String schoolName) async{
    final data = await _getSchoolMessageDataFromDatabase(username, schoolName);
    if (data != null) {
      return _setDataAsMessage(data);
    }
    return null; 
  }
  
  Future<bool> _sendMessageToDatabase(String message, String senderName, String receiverName, MessageMode mode) async{
    final result = await backService.post(
      DioPaths.newMessageForChat.name,
      data: {
        'messageContent' : message,
        'messageDate' : getTime(),
        'messageSender' : senderName,
        'messageReceiver' : receiverName,
        'chatType' : mode.name
      }
    );
    return result.data['status'] == 1;
  }
  
  @override
  Future<bool> sendMessage(String message, String senderName, String receiverName, MessageMode mode) async{
    return await _sendMessageToDatabase(message, senderName, receiverName, mode);
  }
}