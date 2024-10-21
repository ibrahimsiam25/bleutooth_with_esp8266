import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';

class BluetoothConnectCubit extends Cubit<bool> {
  final FlutterSimpleBluetoothPrinter bluetoothManager;
  final String deviceAddress;

  BluetoothConnectCubit(this.bluetoothManager, this.deviceAddress) : super(false);

  StreamSubscription<BTConnectState>? _subscriptionBtStatus;

  void listenToConnectionStatus() {
    _subscriptionBtStatus = bluetoothManager.connectState.listen((status) {
      emit(status == BTConnectState.connected);
    });
  }

  Future<void> connectDevice() async {
    if (state) {
      throw Exception('Already connected to device at: $deviceAddress');
    }

    try {
      bool isConnected = await bluetoothManager.connect(
        address: deviceAddress,
        isBLE: false, // Use false for HC-05
      );

      if (isConnected) {
        emit(true);
      } else {
        throw Exception('Failed to connect to device at: $deviceAddress');
      }
    } on BTException catch (e) {
      throw Exception('Error while trying to connect: $e');
    }
  }

  Future<void> sendData(String wifiName, String wifiPassword) async {
    if (!state) {
      throw Exception('Cannot send data. Not connected to any device.');
    }

    final String data = '$wifiName,$wifiPassword';

    try {
      final isSuccess = await bluetoothManager.writeText(data);
      if (!isSuccess) {
        throw Exception('Failed to send data: $data');
      }
    } on BTException catch (e) {
      throw Exception('Error while sending data: $e');
    }
  }

  void dispose() {
    _subscriptionBtStatus?.cancel();
    close();
  }
}
