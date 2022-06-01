import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:provider/provider.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final _textIPController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Friend by IP'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextField(
                  controller: _textIPController,
                  onSubmitted: (text) => _handleSubmitted(text),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'IP',
                  )),
            ),
            ElevatedButton(
              onPressed: () => _handleSubmitted(_textIPController.text),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String ip) async {
    context.read<AppModel>().addFriend(ip);
  }
}
