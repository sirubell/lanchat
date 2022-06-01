import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:lanchat/widgets/add_friend.dart';
import 'package:lanchat/widgets/chat_room.dart';
import 'package:lanchat/widgets/main_screen.dart';
import 'package:lanchat/widgets/settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LanChat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/settings': (context) => const Settings(),
        '/add-friend': (context) => const AddFriend(),
        '/chat-room': (context) => const ChatRoom(),
      },
    );
  }
}
