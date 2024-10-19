
import 'package:flutter/material.dart';

import '../../manager/network_cubit/network_cubit.dart';

class WifiDetails extends StatelessWidget {
  final NetworkConnected state;

  const WifiDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text("SSID: ${state.wifiName}"),
          leading: const Icon(Icons.wifi),
        ),
        ListTile(
          title: Text("BSSID: ${state.wifiBSSID}"),
          leading: const Icon(Icons.network_wifi),
        ),
        ListTile(
          title: Text("IPv4: ${state.wifiIPv4}"),
          leading: const Icon(Icons.language),
        ),
        ListTile(
          title: Text("IPv6: ${state.wifiIPv6}"),
          leading: const Icon(Icons.language),
        ),
        ListTile(
          title: Text("Gateway IP: ${state.wifiGatewayIP}"),
          leading: const Icon(Icons.router),
        ),
        ListTile(
          title: Text("Broadcast: ${state.wifiBroadcast}"),
          leading: const Icon(Icons.broadcast_on_personal),
        ),
        ListTile(
          title: Text("Subnet Mask: ${state.wifiSubmask}"),
          leading: const Icon(Icons.network_check),
        ),
      ],
    );
  }
}
