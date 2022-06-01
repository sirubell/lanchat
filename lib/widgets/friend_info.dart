import 'package:flutter/material.dart';

class FriendInfo extends StatelessWidget {
  final String name;
  final String ip;
  const FriendInfo({Key? key, required this.name, required this.ip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(ip),
      onTap: () {
        Navigator.pushNamed(context, '/chat-room', arguments: ip);
      },
    );
  }
}
