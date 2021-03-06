import 'dart:typed_data';

import 'package:flutter/widgets.dart';

abstract class MessageModel {
  final bool isMe;
  final DateTime time;
  MessageModel({required this.isMe, required this.time});

  String getMessage();
  String getMessageType();

  Widget? getSubTitle();
  Widget? getTitle();
}
