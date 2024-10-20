import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home/data/model/wifi_credentials.dart';
import '../../manager/cubit/bluetooth_cubit.dart'; // Import your WifiCredentials model

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.wifiCredentials});
  final WifiCredentials wifiCredentials;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BluetoothCubit()..requestPermissions(),
      child: MaterialApp(
        home: BlocConsumer<BluetoothCubit, BluetoothState>(
          listener: (context, state) {
            if (state is BluetoothError) {
              // Handle error state (e.g., show a snackbar)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is BluetoothInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BluetoothDevicesLoaded) {
              return Scaffold(
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
                          context.read<BluetoothCubit>().connect("00:21:09:00:04:B9");
                        },
                      ),
                      SizedBox(height: 30.0),
                      ElevatedButton(
                        child: Text("Send WiFi name and password"),
                        onPressed: () {
                          // Check the state to find the connected Bluetooth connection
                          final cubit = context.read<BluetoothCubit>();
                          final currentState = cubit.state;

                          if (currentState is BluetoothConnected) {
                            cubit.sendData(
                              wifiCredentials.wifiName + wifiCredentials.wifiPassword,
                              currentState.connection, // Access the connection from the connected state
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Not connected to any device")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            // Handle other states like BluetoothConnected, etc.
            return Container();
          },
        ),
      ),
    );
  }
}
