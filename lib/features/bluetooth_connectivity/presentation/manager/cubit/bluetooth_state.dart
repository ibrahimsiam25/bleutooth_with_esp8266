part of 'bluetooth_cubit.dart';

abstract class BluetoothState {}

class BluetoothInitial extends BluetoothState {}

class BluetoothPermissionsGranted extends BluetoothState {}

class BluetoothPermissionsDenied extends BluetoothState {}

class BluetoothDevicesLoaded extends BluetoothState {
  final List<BluetoothDevice> devices;
  BluetoothDevicesLoaded(this.devices);
}

class BluetoothConnected extends BluetoothState {
  final BluetoothConnection connection;
  BluetoothConnected(this.connection);
}

class BluetoothDataSent extends BluetoothState {}

class BluetoothError extends BluetoothState {
  final String message;
  BluetoothError(this.message);
}
