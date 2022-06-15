import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lanchat/constants/constants.dart';
import 'package:lanchat/models/file_message_model.dart';
import 'package:lanchat/models/friend_model.dart';
import 'package:lanchat/models/message_model.dart';
import 'package:lanchat/models/text_message_model.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AppModel extends ChangeNotifier {
  final Map<String, FriendModel> _friends = {};
  String? _ip;
  String name = 'Default Name';
  ServerSocket? server;
  Function? showSnackBar;

  String get base64Name => base64.encode(utf8.encode(name));

  AppModel() {
    final info = NetworkInfo();
    info.getWifiIP().then((value) => _ip = value);

    ServerSocket.bind(InternetAddress.anyIPv4, port).then((server) {
      this.server = server;
      server.listen((Socket client) {
        _handleConnection(client);
      });
    });
  }

  UnmodifiableListView<FriendModel> get friends =>
      UnmodifiableListView(_friends.entries.map((e) => e.value).toList());

  String get ip => _ip ?? '';

  Future<void> addFriend(String ip) async {
    final client = await Socket.connect(ip, port);
    client.write(jsonEncode({'name': base64Name, 'action': 'AskName'}));
    client.close();
    _handleConnection(client);
  }

  Future<void> setName(String name) async {
    this.name = name;
    showSnackBar?.call('Successfully changed name');
  }

  FriendModel? friend(String ip) => _friends[ip];

  Future<void> sendMessage(String ip, MessageModel message) async {
    _friends[ip]!.messages.add(message);
    notifyListeners();

    final data = jsonEncode({
      'action': message.getMessageType(),
      'name': base64Name,
      'time': message.time.toString(),
      'data': message.getMessage(),
    });

    final client = await Socket.connect(ip, port);
    client.write(data);
    client.close();
  }

  void setShowSnackBar(Function f) {
    showSnackBar = f;
  }

  void _ensureFriendExists(String ip, String name) {
    if (_friends[ip] == null) {
      _friends[ip] = FriendModel(ip: ip, name: name);
      showSnackBar?.call('Successfully add a new friend');
    }
    _friends[ip]!.setName(name);
    notifyListeners();
  }

  void _handleAskName(Socket client) {
    client.write(jsonEncode({
      'name': base64Name,
      'action': 'ReplyName',
    }));
    client.close();
  }

  void _handleConnection(Socket client) {
    List<int> buffer = [];
    final ip = client.remoteAddress.address;
    client.listen((Uint8List data) {
      buffer.addAll(data);
    }, onDone: () {
      Map<String, dynamic> json = jsonDecode(String.fromCharCodes(buffer));

      String action = json['action'];
      String name = utf8.decode(base64.decode(json['name']));
      String? time = json['time'];
      String? data = json['data'];

      _ensureFriendExists(ip, name);

      switch (action) {
        case 'AskName':
          _handleAskName(client);
          break;
        case 'ReplyName':
          _handleReplyName(client);
          break;
        case 'Text':
          _handleText(ip, time!, data!);
          break;
        case 'File':
          _handleFile(ip, time!, data!);
          break;
        default:
      }
      client.destroy();
    });
  }

  void _handleFile(String ip, String time, String data) {
    Map<String, dynamic> file = jsonDecode(data);
    String filename = utf8.decode(base64.decode(file['filename']));
    Uint8List filedata = base64.decode(file['filedata']);

    _ensureFriendExists(ip, name);

    _friends[ip]!.messages.add(FileMessageModel(
          isMe: false,
          time: DateTime.parse(time),
          file: PlatformFile(
            name: filename,
            size: filedata.length,
            bytes: filedata,
          ),
        ));
    notifyListeners();
  }

  void _handleReplyName(Socket client) {
    // do nothing
  }

  void _handleText(String ip, String time, String data) {
    String text = utf8.decode(base64.decode(data));

    _friends[ip]!.messages.add(TextMessageModel(
          isMe: false,
          time: DateTime.parse(time),
          text: text,
        ));
    notifyListeners();
  }
}
