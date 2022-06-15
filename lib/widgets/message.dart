import 'package:flutter/material.dart';
import 'package:lanchat/models/message_model.dart';

class Message extends StatelessWidget {
  final MessageModel message;
  const Message({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: message.isMe ? Colors.green.shade100 : Colors.blue.shade100,
        ),
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: message.getTitle(),
          subtitle: message.getSubTitle(),
        ),
      ),
    );
  }
}
