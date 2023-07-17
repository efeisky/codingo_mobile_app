
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ChatSendMessageArea extends StatelessWidget {
  const ChatSendMessageArea({
    super.key,
    required this.device,
    required TextEditingController controller, required this.senderUsername, required this.receiverName, required this.onSending,
  }) : _controller = controller;

  final Size device;
  final String senderUsername;
  final String receiverName;
  final TextEditingController _controller;
  final Future<void> Function(String message, String senderName, String receiverName) onSending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: device.width*.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CustomTextField(
              controller: _controller, 
              hintText: 'Mesaj Gir', 
              prefixIcon: const Icon(Icons.message_rounded), 
              hasSuffixIcon: false, 
              inputAction: TextInputAction.send, 
              autoFillHints: const [AutofillHints.birthday], 
              textInputType: TextInputType.multiline
            )
          ),
          IconButton(
            onPressed: () async{
              await onSending(_controller.text,senderUsername,receiverName);
              _controller.clear();
            }, 
            icon: ImagePaths.message_send_icon.toWidget()
          )
        ],
      )
    );
  }
}



