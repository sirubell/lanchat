import 'package:lanchat/models/message_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileMessageModel extends MessageModel {
  final PlatformFile file;
  FileMessageModel({required isMe, required time, required this.file})
      : super(isMe: isMe, time: time);

  @override
  String getMessage() =>
      "${super.getMessage()}${file.name}\n${String.fromCharCodes(file.bytes!)}";

  @override
  String getMessageType() => "File";

  @override
  Widget? getTitle() => Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(file.name),
      );

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
}
