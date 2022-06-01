import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lanchat/constants/constants.dart';
import 'package:lanchat/models/file_message_model.dart';
import 'package:lanchat/models/friend_model.dart';
import 'package:lanchat/models/message_model.dart';
import 'package:lanchat/models/text_message_model.dart';

class AppModel extends ChangeNotifier {
  final Map<String, FriendModel> _friends = {};
  final Map<String, List<int>> _buffer = {};
  final String name = 'Default Name';
  ServerSocket? server;
  Function? showSnackBar;

  AppModel() {
    ServerSocket.bind(InternetAddress.anyIPv4, port).then((server) {
      this.server = server;
      server.listen((client) {
        _handleConnection(client);
      });
    });
  }

  UnmodifiableListView<FriendModel> get friends =>
      UnmodifiableListView(_friends.entries.map((e) => e.value).toList());

  Future<void> addFriend(String ip) async {
    final client = await Socket.connect(ip, port);
    client.writeln(name);
    client.writeln("AskName");
    client.write(socketEndIndicator);
    client.flush();
    _handleConnection(client);
  }

  FriendModel? friend(String ip) => _friends[ip];

  void replyName(Socket client) {
    client.writeln(name);
    client.writeln("ReplyName");
    client.write(socketEndIndicator);
    client.flush();
  }

  Future<void> sendMessage(String ip, MessageModel message) async {
    _friends[ip]?.messages.add(message);
    notifyListeners();

    debugPrint(
        "Send file size (+time +name): ${message.getMessage().length.toString()}");

    final socket = await Socket.connect(ip, port);

    socket.writeln(name);
    socket.writeln(message.getMessageType());
    socket.write(message.getMessage());
    socket.write(socketEndIndicator);
    socket.flush();
  }

  void setShowSnackBar(Function f) {
    showSnackBar = f;
  }

  void _handleConnection(Socket client) {
    client.listen(
      (Uint8List data) {
        final ip = client.remoteAddress.address;
        if (_buffer[ip] == null) {
          _buffer[ip] = [];
        }

        if (data.length < socketEndIndicator.length) {
          _buffer[ip]!.addAll(data);
        } else {
          if (String.fromCharCodes(
                  data.sublist(data.length - socketEndIndicator.length)) ==
              socketEndIndicator) {
            _buffer[ip]!.addAll(
              data.sublist(0, data.length - socketEndIndicator.length),
            );

            _handleData(client);
            client.destroy();
          } else {
            _buffer[ip]!.addAll(data);
          }
        }
      },
      onError: (error) {
        client.destroy();
      },
      onDone: () {
        client.destroy();
      },
    );
  }

  void _handleData(Socket client) {
    final ip = client.remoteAddress.address;
    final data = _buffer[ip]!;

    final nameidx = data.indexOf('\n'.codeUnitAt(0));
    final actionidx = data.indexOf('\n'.codeUnitAt(0), nameidx + 1);
    final name = String.fromCharCodes(data, 0, nameidx);
    final action = String.fromCharCodes(data, nameidx + 1, actionidx);
    final message = data.sublist(actionidx + 1);

    debugPrint("Received action: $action");

    _buffer[ip]!.clear();

    if (!_friends.containsKey(ip)) {
      _friends[ip] = FriendModel(ip: ip);
      showSnackBar?.call('Successfully add a new friend');
    }
    _friends[ip]!.setName(name);
    notifyListeners();

    switch (action) {
      case "AskName":
        replyName(client);
        break;
      case "ReplyName":
        break;
      default:
        _receiveMessage(ip, action, Uint8List.fromList(message));
    }
  }

  void _receiveFileMessage(String ip, String time, Uint8List data) async {
    final nameidx = data.indexOf('\n'.codeUnitAt(0));
    final name = String.fromCharCodes(data, 0, nameidx);
    final filedata = data.sublist(nameidx + 1);
    debugPrint("Received file size: ${filedata.length.toString()}");

    _friends[ip]!.messages.add(FileMessageModel(
          isMe: false,
          time: DateTime.parse(time),
          file: PlatformFile(
            name: name,
            size: filedata.length,
            bytes: filedata,
          ),
        ));
    notifyListeners();
  }

  void _receiveMessage(String ip, String action, Uint8List message) {
    final timeidx = message.indexOf('\n'.codeUnitAt(0));
    final time = String.fromCharCodes(message, 0, timeidx);
    final data = message.sublist(timeidx + 1);

    switch (action) {
      case "Text":
        _receiveTextMessage(ip, time, data);
        break;
      case "Image":
        // _receiveImageMessage(ip, time, data);
        break;
      case "File":
        _receiveFileMessage(ip, time, data);
        break;
      default:
    }
  }

  void _receiveTextMessage(String ip, String time, Uint8List data) async {
    _friends[ip]!.messages.add(TextMessageModel(
          isMe: false,
          time: DateTime.parse(time),
          text: String.fromCharCodes(data),
        ));
    notifyListeners();
  }
}
