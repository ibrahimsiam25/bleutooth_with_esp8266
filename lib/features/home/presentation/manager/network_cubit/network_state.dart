part of 'network_cubit.dart';

abstract class NetworkState {}

class NetworkInitial extends NetworkState {}

class NetworkDisconnected extends NetworkState {}

class NetworkConnected extends NetworkState {
  final String? wifiName;
  final String? wifiBSSID;
  final String? wifiIPv4;
  final String? wifiIPv6;
  final String? wifiGatewayIP;
  final String? wifiBroadcast;
  final String? wifiSubmask;

  NetworkConnected({
    required this.wifiName,
    required this.wifiBSSID,
    required this.wifiIPv4,
    required this.wifiIPv6,
    required this.wifiGatewayIP,
    required this.wifiBroadcast,
    required this.wifiSubmask,
  });
}
