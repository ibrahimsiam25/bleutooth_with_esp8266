import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


import 'package:permission_handler/permission_handler.dart';part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<BluetoothState> {
  BluetoothCubit() : super(BluetoothInitial());

  Future<void> requestPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.bluetoothConnect]?.isGranted == true &&
        statuses[Permission.bluetoothScan]?.isGranted == true) {
      emit(BluetoothPermissionsGranted());
    } else {
      emit(BluetoothPermissionsDenied());
    }
  }

  Future<void> loadDevices() async {
    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      emit(BluetoothDevicesLoaded(devices));
    } catch (e) {
      emit(BluetoothError("Error getting bonded devices: $e"));
    }
  }

  Future<void> connect(String address) async {
    try {
      final connection = await BluetoothConnection.toAddress(address);
      emit(BluetoothConnected(connection));
      sendData('111', connection);
    } catch (e) {
      emit(BluetoothError("Cannot connect, exception occurred: $e"));
    }
  }

  Future<void> sendData(String data, BluetoothConnection connection) async {
    data = data.trim();
    try {
      final bytes = Uint8List.fromList(data.codeUnits);
      connection.output.add(bytes);
      await connection.output.allSent;
      emit(BluetoothDataSent());
    } catch (e) {
      emit(BluetoothError("Failed to send data: $e"));
    }
  }
}