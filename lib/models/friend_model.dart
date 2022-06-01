import 'package:lanchat/models/message_model.dart';

class FriendModel {
  String name = "No Name";
  final String ip;
  List<MessageModel> messages = [];

  FriendModel({required this.ip, name});

  void setName(String name) {
    this.name = name;
  }
}
