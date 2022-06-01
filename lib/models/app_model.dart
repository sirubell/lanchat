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
  HttpServer? server;
  Function? showSnackBar;

  AppModel() {
    final info = NetworkInfo();
    info.getWifiIP().then((value) => _ip = value);

    HttpServer.bind(InternetAddress.anyIPv4, port).then((server) {
      this.server = server;
      server.listen((HttpRequest request) {
        _handleRequest(request);
      });
    });
  }

  UnmodifiableListView<FriendModel> get friends =>
      UnmodifiableListView(_friends.entries.map((e) => e.value).toList());

  String get ip => _ip ?? '';

  Future<void> addFriend(String ip) async {
    final client = HttpClient();
    try {
      HttpClientRequest request = await client.get(ip, port, '/AskName');
      HttpClientResponse response = await request.close();
      response.listen((data) {
        Map<String, dynamic> json = jsonDecode(String.fromCharCodes(data));
        String ip = json['ip'];
        String name = utf8.decode(json['name'].cast<int>());

        _ensureFriendExists(ip, name);
      });
    } finally {
      client.close();
    }
  }

  FriendModel? friend(String ip) => _friends[ip];

  Future<void> sendMessage(String ip, MessageModel message) async {
    _friends[ip]!.messages.add(message);
    notifyListeners();

    final client = HttpClient();
    try {
      HttpClientRequest request =
          await client.post(ip, port, '/${message.getMessageType()}');
      request.write(jsonEncode({
        'ip': this.ip,
        'name': utf8.encode(name),
        'time': message.time.toString(),
        'data': message.getMessage(),
      }));
      request.close();
    } finally {
      client.close();
    }
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

  void _handleAskName(HttpRequest request) {
    request.response.write(jsonEncode({
      'ip': ip,
      'name': utf8.encode(name),
    }));
    request.response.close();
  }

  void _handleFile(HttpRequest request) {
    List<int> buffer = [];
    request.listen((Uint8List data) {
      buffer.addAll(data);
    }, onDone: () {
      Map<String, dynamic> json = jsonDecode(String.fromCharCodes(buffer));
      String ip = json['ip'];
      String name = utf8.decode(json['name'].cast<int>());
      String time = json['time'];
      Map<String, dynamic> file =
          jsonDecode(String.fromCharCodes(json['data'].cast<int>()));
      String filename = utf8.decode(file['filename'].cast<int>());
      Uint8List filedata = Uint8List.fromList(file['filedata'].cast<int>());

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
      request.response.close();
    });
  }

  void _handleRequest(HttpRequest request) {
    debugPrint(request.uri.path);

    switch (request.uri.path) {
      case '/Ping':
        request.response.write('Pong');
        break;
      case '/AskName':
        _handleAskName(request);
        break;
      case '/Text':
        _handleText(request);
        break;
      case '/File':
        _handleFile(request);
        break;
    }
  }

  void _handleText(HttpRequest request) {
    request.listen((Uint8List data) {
      Map<String, dynamic> json = jsonDecode(String.fromCharCodes(data));
      String ip = json['ip'];
      String name = utf8.decode(json['name'].cast<int>());
      String time = json['time'];
      String text = utf8.decode(json['data'].cast<int>());

      _ensureFriendExists(ip, name);

      _friends[ip]!.messages.add(TextMessageModel(
            isMe: false,
            time: DateTime.parse(time),
            text: text,
          ));
      notifyListeners();
      request.response.close();
    });
  }
}
