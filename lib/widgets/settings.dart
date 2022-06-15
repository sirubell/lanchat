import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String ip = context.watch<AppModel>().ip;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("My IP: $ip"),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (text) => _handleSubmitted(text),
                        decoration: const InputDecoration(
                          hintText: 'My Name',
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleSubmitted(_controller.text),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    context.read<AppModel>().setName(text);
  }
}
