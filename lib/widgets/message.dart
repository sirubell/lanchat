import 'package:flutter/material.dart';
import 'package:lanchat/models/message_model.dart';

class Message extends StatelessWidget {
  final MessageModel message;
  const Message({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: message.getTitle(),
      subtitle: message.getSubTitle(),
    );
  }
}
