// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:codingo/product/theme/font_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/user_message/model/user_message_model.dart';
import 'package:codingo/views/user_message/service/user_message_service.dart';

class UserMessageView extends StatefulWidget {
  const UserMessageView({super.key});

  @override
  State<UserMessageView> createState() => _UserMessageViewState();
}

class _UserMessageViewState extends State<UserMessageView> with NavigatorMixin {
  String _initialUsername = '';
  String? _schoolName;
  final _currentPage = NavigatorRoutesPaths.userMessage;
  late final MessageService _service;

  @override
  void initState() {
    super.initState();
    _service = MessageService();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _getSchoolName();
  }

  Future<List<UserMessageModel>?> _fetchMessageList() async {
    return await _service.getMessageList(_initialUsername);
  }
  Future<void> _getSchoolName() async {
    final response = await _service.getSchoolName(_initialUsername);
    if (response != null && response.isNotEmpty) {
      setState(() {
        _schoolName = response;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    const sizedBox = SizedBox.shrink();
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Mesajlarım',
      ),
      body: Column(
        children: [
          if (_schoolName != null) 
          InkWell(
            onTap: () {
              router.pushReplacementToPage(NavigatorRoutesPaths.messageAsSchool,arguments: _schoolName);
            },
            child: _SchoolTile(schoolName: _schoolName),
          ) else sizedBox,
          Expanded(
            child: FutureBuilder<List<UserMessageModel>?>(
              future: _fetchMessageList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _progress();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else {
                  final messageList = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      final message = messageList[index];
                      return _UserTile(device: device, message: message, router: router);
                    },
                  );
                }
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
          color: _MessageTheme.progressColor,
        ),
      );
}

class _SchoolTile extends StatelessWidget {
  const _SchoolTile({
    super.key,
    required String? schoolName,
  }) : _schoolName = schoolName;

  final String? _schoolName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${_schoolName!} Sohbeti',
        style: const TextStyle(
          fontFamily: FontTheme.fontFamily,
          fontSize: FontTheme.bfontSize,
          fontWeight: FontTheme.xfontWeight
        ),
        ),
        subtitle: const Text('Okul Grubu Sohbeti'),
        trailing: const Icon(Icons.chevron_right_rounded, size: 32,),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    Key? key,
    required this.device,
    required this.message,
    required this.router,
  }) : super(key: key);

  final Size device;
  final UserMessageModel message;
  final NavigatorManager router;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: device.width*.05, vertical: device.height*.02),
      leading: message.picture == '' ? ImagePaths.unknown.toWidget() : ImageNetworkWidget(pictureSrc: message.picture),
      title: Text(message.username),
      subtitle: Text(message.lastContent.length > _MessageTheme.maxWordCount
      ? '${message.lastContent.substring(0, _MessageTheme.maxWordCount)}...'
      : message.lastContent),
      trailing: message.isRead == false && message.lastMessageSentByUser == 0 ? 
      const Icon(Icons.done_all_rounded,color: _MessageTheme.progressColor,): null,
      onTap: () {
        router.pushReplacementToPage(NavigatorRoutesPaths.messageAsUser,arguments: message.username);
      },
    );
  }
}

class _MessageTheme {
  static const Color progressColor = Color.fromRGBO(92, 74, 203, 1);
  static const int maxWordCount = 50;
}