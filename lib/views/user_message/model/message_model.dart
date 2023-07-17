class MessageModel {
  late final String content;
  late final DateTime date;
  late final bool messageSender;

  MessageModel({
    required this.content,
    required this.date,
    required this.messageSender,
  });
}