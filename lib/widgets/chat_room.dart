import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:lanchat/widgets/text_composer.dart';
import 'package:lanchat/widgets/message.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ip = ModalRoute.of(context)!.settings.arguments as String;
    final friend = context.watch<AppModel>().friend(ip)!;

    return Scaffold(
      appBar: AppBar(title: Text(friend.name)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemBuilder: (_, index) => Message(
                message: friend.messages[friend.messages.length - 1 - index],
              ),
              itemCount: friend.messages.length,
            ),
          ),
          const Divider(),
          TextComposer(ip: ip),
        ],
      ),
    );
  }
}
