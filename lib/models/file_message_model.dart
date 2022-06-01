import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lanchat/models/message_model.dart';

class FileMessageModel extends MessageModel {
  final PlatformFile file;
  FileMessageModel({required isMe, required time, required this.file})
      : super(isMe: isMe, time: time);

  @override
  String getMessage() => jsonEncode({
        'filename': base64.encode(utf8.encode(file.name)),
        'filedata': base64.encode(file.bytes!),
      });

  @override
  String getMessageType() => "File";

  @override
  Widget? getSubTitle() {
    switch (file.extension) {
      case "png":
      case "jpg":
        return Image.memory(file.bytes!);
      default:
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: const Icon(Icons.file_open),
        );
    }
  }

  @override
  Widget? getTitle() => Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(file.name),
      );
}
