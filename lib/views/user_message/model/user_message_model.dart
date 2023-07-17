class UserMessageModel {
  late final String username;
  late final String picture;
  late final String lastContent;
  late final DateTime lastChatTime;
  late final int lastMessageSentByUser;
  late final bool isRead;

  UserMessageModel({
    required this.username,
    required this.picture,
    required this.lastContent,
    required this.lastChatTime,
    required this.lastMessageSentByUser,
    required this.isRead,
  });
}