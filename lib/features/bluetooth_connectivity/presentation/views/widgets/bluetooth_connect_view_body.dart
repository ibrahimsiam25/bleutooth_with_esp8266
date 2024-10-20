import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home/data/model/wifi_credentials.dart';
import '../../manager/cubit/bluetooth_cubit.dart'; // Import your WifiCredentials model
class BluetoothConnectViewBody extends StatelessWidget {
  const BluetoothConnectViewBody({super.key, required this.wifiCredentials});
  final WifiCredentials wifiCredentials;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BluetoothCubit()..requestPermissions(),
      child: BlocConsumer<BluetoothCubit, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BluetoothInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BluetoothDevicesLoaded) {
            return _buildDeviceList(context);
          }

          if (state is BluetoothConnected) {
            return _buildConnectedUI(context);
          }

          return const Center(child: Text("Awaiting Bluetooth connection..."));
        },
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("MAC Address: 00:21:09:00:04:B9"),
          ElevatedButton(
            child: const Text("Connect"),
            onPressed: () {
              context.read<BluetoothCubit>().connect("00:21:09:00:04:B9");
            },
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            child: const Text("Send WiFi name and password"),
            onPressed: () {
              _sendData(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Connected to device"),
          ElevatedButton(
            child: const Text("Send WiFi name and password"),
            onPressed: () {
              _sendData(context);
            },
          ),
        ],
      ),
    );
  }

  void _sendData(BuildContext context) {
    final cubit = context.read<BluetoothCubit>();
    if (cubit.state is BluetoothConnected) {
      cubit.sendData(wifiCredentials.wifiName, wifiCredentials.wifiPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not connected to any device")),
      );
    }
  }
}
