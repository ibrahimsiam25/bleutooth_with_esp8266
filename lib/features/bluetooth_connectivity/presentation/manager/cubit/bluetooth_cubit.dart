
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    final hasAllPermissions = statuses.values.every((status) => status.isGranted);
    if (hasAllPermissions) {
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
    } catch (e) {
      emit(BluetoothError("Cannot connect, exception occurred: $e"));
    }
  }

  Future<void> sendData(String wifiName, String wifiPassword) async {
    final data = '$wifiName,$wifiPassword'.trim();
    try {
      final bytes = Uint8List.fromList(data.codeUnits);
      final currentState = state;

      if (currentState is BluetoothConnected) {
        currentState.connection.output.add(bytes);
        await currentState.connection.output.allSent;
        if (kDebugMode) {
          print('Data sent successfully: $data');
        }
      } else {
        emit(BluetoothError("No active Bluetooth connection."));
      }
    } catch (e) {
      emit(BluetoothError("Failed to send data: $e"));
    }
  }
}
