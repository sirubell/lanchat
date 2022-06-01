import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Settings extends StatelessWidget {
  static final info = NetworkInfo();
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String?>(
              future: info.getWifiIP(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                String wifiIP;
                if (snapshot.hasData) {
                  wifiIP = snapshot.data;
                } else if (snapshot.hasError) {
                  wifiIP = "Could not get IP address";
                } else {
                  wifiIP = "Getting IP address";
                }
                return Text("My IP: $wifiIP");
              }),
        ],
      )),
    );
  }
}
