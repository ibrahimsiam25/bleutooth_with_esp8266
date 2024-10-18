import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});
  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _initNetworkInfo();
    await _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    developer.log('Connectivity status: $result');
  }

  Future<void> _initNetworkInfo() async {
    final hasPermission = await _requestLocationPermission();
    final wifiInfo = {
      'Wifi Name': await _getNetworkInfo(_networkInfo.getWifiName, hasPermission, 'Wifi Name'),
      'Wifi BSSID': await _getNetworkInfo(_networkInfo.getWifiBSSID, hasPermission, 'Wifi BSSID'),
      'Wifi IPv4': await _getNetworkInfo(_networkInfo.getWifiIP, true, 'Wifi IPv4'),
      'Wifi IPv6': await _getNetworkInfo(_networkInfo.getWifiIPv6, true, 'Wifi IPv6'),
      'Wifi Submask': await _getNetworkInfo(_networkInfo.getWifiSubmask, true, 'Wifi Submask'),
      'Wifi Broadcast': await _getNetworkInfo(_networkInfo.getWifiBroadcast, true, 'Wifi Broadcast'),
      'Wifi Gateway': await _getNetworkInfo(_networkInfo.getWifiGatewayIP, true, 'Wifi Gateway')
    };

    setState(() {
      _connectionStatus = wifiInfo.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    });
  }

  Future<bool> _requestLocationPermission() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return await Permission.locationWhenInUse.request().isGranted;
    }
    return true;
  }

  Future<String> _getNetworkInfo(
      Future<String?> Function() networkCall, bool hasPermission, String infoType) async {
    try {
      if (hasPermission) {
        final result = await networkCall();
        return result ?? 'Not available';
      }
      return 'Unauthorized to get $infoType';
    } on PlatformException catch (e) {
      developer.log('Failed to get $infoType', error: e);
      return 'Failed to get $infoType';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetworkInfoPlus example'),
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Network info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(_connectionStatus),
          ],
        ),
      ),
    );
  }
}
