import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';

import '../../../../home/data/model/wifi_credentials.dart';

class BluetoothConnectViewBody extends StatefulWidget {
  const BluetoothConnectViewBody({super.key, required this.wifiCredentials});
  final WifiCredentials wifiCredentials;

  @override
  State<BluetoothConnectViewBody> createState() => _BluetoothConnectViewBodyState();
}

class _BluetoothConnectViewBodyState extends State<BluetoothConnectViewBody> {
  final bluetoothManager = FlutterSimpleBluetoothPrinter.instance;
  bool _isConnected = false;
  StreamSubscription<BTConnectState>? _subscriptionBtStatus;
  final String adr = "00:21:09:00:04:B9"; // عنوان الـ MAC المطلوب

  @override
  void initState() {
    super.initState();
    _listenToConnectionStatus();
  }

  @override
  void dispose() {
    _subscriptionBtStatus?.cancel();
    super.dispose();
  }

  void _listenToConnectionStatus() {
    _subscriptionBtStatus = bluetoothManager.connectState.listen((status) {
      setState(() {
        _isConnected = status == BTConnectState.connected;
      });
    });
  }

  Future<void> _connectDevice() async {
    if (_isConnected) {
      _showSnackbar('متصل بالفعل بالجهاز مع العنوان: $adr');
      return;
    }

    try {
      _isConnected = await bluetoothManager.connect(
        address: adr,
        isBLE: false, // استخدم false لـ HC-05 (ليس جهاز BLE)
      );

      setState(() {});
      if (_isConnected) {
        _showSnackbar('تم الاتصال بنجاح بالجهاز مع العنوان: $adr');
      } else {
        _showSnackbar('فشل الاتصال بالجهاز مع العنوان: $adr');
      }
    } on BTException catch (e) {
      _showSnackbar('خطأ أثناء محاولة الاتصال: $e');
      print('خطأ أثناء محاولة الاتصال: $e');
    }
  }

  Future<void> _sendData() async {
    if (!_isConnected) {
      _showSnackbar('لا يمكن إرسال البيانات. غير متصل بأي جهاز.');
      return;
    }

    final String data = '${widget.wifiCredentials.wifiName},${widget.wifiCredentials.wifiPassword}';

    try {
      final isSuccess = await bluetoothManager.writeText(data);
      if (isSuccess) {
        _showSnackbar('تم إرسال البيانات بنجاح: $data');
      } else {
        _showSnackbar('فشل في إرسال البيانات: $data');
      }
    } on BTException catch (e) {
      _showSnackbar('خطأ أثناء إرسال البيانات: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _connectDevice,
            child: const Text("اتصال"),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _isConnected ? _sendData : null,
            child: const Text("إرسال اسم وكلمة مرور الواي فاي"),
          ),
          const SizedBox(height: 20.0),
          if (_isConnected) const Text('تم الاتصال بالجهاز بنجاح'),
        ],
      ),
    );
  }
}
