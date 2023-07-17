import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/user_message/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
    required this.device,
  });

  final MessageModel message;
  final Size device;

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 10,);
    return FractionallySizedBox(
      alignment: message.messageSender ? Alignment.topRight : Alignment.topLeft,
      widthFactor: 0.65,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 20,horizontal: device.width * .05),
        decoration: BoxDecoration(
          color: message.messageSender ? const Color(0xFF4285F4) : Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: message.messageSender ? Colors.white : Colors.black,
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.xsfontSize,
                fontWeight: FontTheme.rfontWeight
              ),
            ),
            sizedBox,
            Text(
              DateFormat('dd MMMM yyyy', 'tr_TR').format(DateTime.now()),
              style: TextStyle(
                color: message.messageSender ? Colors.grey.shade200 : Colors.grey.shade700,
                fontFamily: FontTheme.fontFamily,
                fontSize: FontTheme.xsfontSize,
                fontWeight: FontTheme.rfontWeight
              ),
            )
          ],
        ),
      ),
    );
  }
}
