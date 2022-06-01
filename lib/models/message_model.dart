import 'package:flutter/widgets.dart';

abstract class MessageModel {
  final bool isMe;
  final DateTime time;
  MessageModel({required this.isMe, required this.time});

  String getMessageType();
  String getMessage() => "${time.toString()}\n";

  Widget? getTitle();
  Widget? getSubTitle();
}
