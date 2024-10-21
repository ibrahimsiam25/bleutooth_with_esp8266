import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';
import '../../../../home/data/model/wifi_credentials.dart';
import '../../manager/cubit/bluetooth_connect_cubit.dart';


class BluetoothConnectViewBody extends StatelessWidget {
  const BluetoothConnectViewBody({super.key, required this.wifiCredentials});
  final WifiCredentials wifiCredentials;

  @override
  Widget build(BuildContext context) {
    final bluetoothManager = FlutterSimpleBluetoothPrinter.instance;
    const String adr = "00:21:09:00:04:B9"; // Target MAC address

    return BlocProvider(
      create: (_) => BluetoothConnectCubit(bluetoothManager, adr)..listenToConnectionStatus(),
      child: BlocConsumer<BluetoothConnectCubit, bool>(
        listener: (context, isConnected) {
          if (isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully connected to the device')),
            );
          }
        },
        builder: (context, isConnected) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final cubit = context.read<BluetoothConnectCubit>();
                    cubit.connectDevice().catchError((error) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    });
                  },
                  child: const Text("Connect"),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: isConnected
                      ? () {
                          final cubit = context.read<BluetoothConnectCubit>();
                          cubit.sendData(wifiCredentials.wifiName, wifiCredentials.wifiPassword).catchError((error) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          });
                        }
                      : null,
                  child: const Text("Send WiFi Name and Password"),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
