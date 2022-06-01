import 'package:flutter/material.dart';
import 'package:lanchat/models/app_model.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
        ],
      )),
    );
  }
}
