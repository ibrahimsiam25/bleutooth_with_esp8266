import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<BluetoothDevice> _devices = [];
  late BluetoothConnection connection;
  String adr = "00:21:09:00:04:B9"; 

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // طلب الأذونات عند بدء التطبيق
    _loadDevices();
  }

  Future<void> _requestPermissions() async {
    // طلب الأذونات اللازمة
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    // تحقق من حالة الأذونات
    if (statuses[Permission.bluetoothConnect]?.isGranted == true &&
        statuses[Permission.bluetoothScan]?.isGranted == true) {
      // الأذونات ممنوحة
      if (kDebugMode) {
        print("Bluetooth permissions granted.");
      }
    } else {
      // الأذونات مرفوضة
      if (kDebugMode) {
        print("Bluetooth permissions denied.");
      }
    }
  }

  Future<void> _loadDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      // Handle the error if permissions are not granted
      if (kDebugMode) {
        print("Error getting bonded devices: $e");
      }
    }
  }

  Future<void> sendData(String data) async {
    data = data.trim();
    try {
      List<int> list = data.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      connection.output.add(bytes);
      await connection.output.allSent;
      if (kDebugMode) {
        print('Data sent successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Bluetooth Single LED Control"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("MAC Address: 00:21:09:00:04:B9"),
              ElevatedButton(
                child: Text("Connect"),
                onPressed: () {
                  connect(adr);
                },
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                child: Text("OPEN"),
                onPressed: () {
                  sendData("on");
                },
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                child: Text("CLOSE"),
                onPressed: () {
                  sendData("off");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      sendData('111');
      connection.input!.listen((Uint8List data) {
        // Data entry point
      });
    } catch (exception) {
      print("Cannot connect, exception occurred");
    }
  }
}
