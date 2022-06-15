import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:lanchat/widgets/friend_info.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AppModel>().setShowSnackBar((String message) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    final friends = context.watch<AppModel>().friends;
    return Scaffold(
      appBar: AppBar(
        title: const Text('LanChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-friend');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('All Friends:'),
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, index) {
                return FriendInfo(
                  name: friends[index].name,
                  ip: friends[index].ip,
                );
              },
              itemCount: friends.length,
            ),
          ),
        ],
      ),
    );
  }
}
