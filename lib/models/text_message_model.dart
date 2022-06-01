import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lanchat/models/message_model.dart';

class TextMessageModel extends MessageModel {
  final String text;
  TextMessageModel({required isMe, required time, required this.text})
      : super(isMe: isMe, time: time);

  @override
  List<int> getMessage() => utf8.encode(text);

  @override
  String getMessageType() => "Text";

  @override
  Widget? getSubTitle() => null;

  @override
  Widget? getTitle() => Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(text),
      );
}
