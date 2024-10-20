import 'package:bleutooth_with_esp8266/features/bluetooth_connectivity/presentation/views/widgets/bluetooth_connect_view_body.dart';
import 'package:bleutooth_with_esp8266/features/home/data/model/wifi_credentials.dart';
import 'package:flutter/material.dart';

class BluetoothConnectView extends StatelessWidget {
  const BluetoothConnectView({super.key,  required this.wifiCredentials});
final WifiCredentials wifiCredentials;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyApp(wifiCredentials: wifiCredentials),
    );
  }
}