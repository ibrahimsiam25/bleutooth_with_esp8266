
import 'package:bleutooth_with_esp8266/features/home/presentation/views/widgets/password_section.dart';
import 'package:bleutooth_with_esp8266/features/home/presentation/views/widgets/wifi_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/network_cubit/network_cubit.dart';

class WifiInfo extends StatelessWidget {
  final String password;
  final VoidCallback onPasswordChange;

  const WifiInfo({
    super.key,
    required this.password,
    required this.onPasswordChange,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<NetworkCubit>().state;
    if (state is! NetworkConnected) return Container();

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Connected to WiFi",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              WifiDetails(state: state),
              const SizedBox(height: 16),
              PasswordSection(
                password: password,
                onPasswordChange: onPasswordChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
