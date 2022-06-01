import 'package:flutter/material.dart';
import 'package:lanchat/models/message_model.dart';

class TextMessageModel extends MessageModel {
  final String text;
  TextMessageModel({required isMe, required time, required this.text})
      : super(isMe: isMe, time: time);

  @override
  String getMessage() => super.getMessage() + text;

  @override
  String getMessageType() => "Text";

  @override
  Widget? getTitle() => Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(text),
      );

  @override
  Widget? getSubTitle() => null;
}
