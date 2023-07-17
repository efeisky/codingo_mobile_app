import 'dart:async';

import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/options_pages/user_follow/feature/error_not_found.dart';
import 'package:codingo/views/user_message/feature/message_pages/chat_message_send.dart';
import 'package:codingo/views/user_message/feature/message_pages/chat_user_app_bar.dart';
import 'package:codingo/views/user_message/feature/message_pages/message_container.dart';
import 'package:codingo/views/user_message/feature/message_pages/message_error.dart';
import 'package:codingo/views/user_message/feature/message_pages/message_theme.dart';
import 'package:codingo/views/user_message/model/message_model.dart';
import 'package:codingo/views/user_message/model/user_profile_model.dart';
import 'package:codingo/views/user_message/service/user_message_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:codingo/product/global/user_context.dart';

class ChatSchoolView extends StatefulWidget {
  const ChatSchoolView({Key? key}) : super(key: key);

  @override
  State<ChatSchoolView> createState() => _ChatSchoolViewState();
}

class _ChatSchoolViewState extends State<ChatSchoolView> with NavigatorMixin {
  String _talkedSchoolName = '';
  final _currentPage = NavigatorRoutesPaths.userMessage;
  String _initialUsername = '';
  late final MessageService _service;
  late UserProfileModel _profileModel;
  late final TextEditingController _controller;
  late final StreamController<List<MessageModel>?> _messageStreamController;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = MessageService();
    _profileModel = UserProfileModel(username: '...', realname: '...', picture: 'school');
    _controller = TextEditingController();
    _messageStreamController = StreamController<List<MessageModel>?>();

    () async {
      await _initializeValue();
      await _fetchProfileData();
      await _fetchMessageData();
    }();
  }

  Future<void> _initializeValue() async {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if (modelArgs != null && modelArgs is String) {
          _talkedSchoolName = modelArgs;
        }
      });
    });
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _profileModel = UserProfileModel(username: '', realname: _talkedSchoolName, picture: 'school');
    });
  }

  Future<void> _fetchMessageData() async {
    final messages = await _service.getSchoolMessageData(_initialUsername, _talkedSchoolName);
    _messageStreamController.add(messages);
  }

  Future<void> _sendMessage(String message, String senderName, String receiverName) async {
    final response = await _service.sendMessage(
      message,
      senderName,
      receiverName,
      MessageMode.school,
    );
    if (response == true) {
      await _fetchMessageData();
    } else {
      messageAlert(context, 'Mesaj gönderilemedi !');
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ChatAppBar(
        context: context,
        model: _profileModel,
        router: router,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 8,
            child: StreamBuilder<List<MessageModel>?>(
              stream: _messageStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _progress();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else {
                  final List<MessageModel>? messages = snapshot.data;
                  if (messages != null && messages.isNotEmpty) {
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return MessageWidget(message: message, device: device);
                      },
                    );
                  }
                }
                return ErrorNotFound(
                  device: device,
                  text: 'Hiç mesaj bulunamadı.',
                );
              },
            ),
          ),
          Flexible(
            flex: 2,
            child: ChatSendMessageArea(
              device: device,
              controller: _controller,
              senderUsername: _initialUsername,
              receiverName: _talkedSchoolName,
              onSending: (String message, String senderName, String receiverName) async {
                _sendMessage(message, senderName, receiverName);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(activePage: _currentPage),
    );
  }

  Center _progress() => const Center(
        child: CircularProgressIndicator(
          color: MessageTheme.appFgColor,
        ),
      );

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }
}
