import 'package:bleutooth_with_esp8266/core/routes/app_router.dart';
import 'package:bleutooth_with_esp8266/features/home/data/model/wifi_credentials.dart';
import 'package:bleutooth_with_esp8266/features/home/presentation/views/widgets/wifi_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../../../core/widgets/show_text_field_dialog.dart';
import '../../manager/network_cubit/network_cubit.dart';
import '../../manager/password/password_cubit.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  void _showPasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    await showTextFieldDialog(context, passwordController);
    // ignore: use_build_context_synchronously
    context.read<PasswordCubit>().updatePassword(passwordController.text);
  }

  void _validatePassword(BuildContext context) {
    final passwordState = context.read<PasswordCubit>().state;
    if (passwordState is PasswordUpdated && passwordState.password.isNotEmpty) {
      print(passwordState.password);
      print(context.read<NetworkCubit>().wifiSSid);
      GoRouter.of(context).push(AppRouter.kBluetoothConnectView,extra: 
      WifiCredentials(wifiName: context.read<NetworkCubit>().wifiSSid??"not found", wifiPassword: passwordState.password)
      );
    } else {
      // Show an error message if the password is empty.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the password for WiFi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NetworkCubit(NetworkInfo(), Connectivity()),
        ),
        BlocProvider(
          create: (_) => PasswordCubit(),
        ),
      ],
      child: BlocBuilder<NetworkCubit, NetworkState>(
        builder: (context, networkState) {
          if (networkState is NetworkDisconnected) {
            return const Center(child: Text('No WiFi Connection'));
          } else if (networkState is NetworkConnected) {
            return BlocBuilder<PasswordCubit, PasswordState>(
              builder: (context, passwordState) {
                String password = '';
                if (passwordState is PasswordUpdated) {
                  password = passwordState.password;
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WifiInfo(
                        password: password,
                        onPasswordChange: () => _showPasswordDialog(context),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _validatePassword(context),
                        child: const Text('Connect to bluetooth'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }}