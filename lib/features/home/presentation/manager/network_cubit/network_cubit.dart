import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo _networkInfo;
  final Connectivity _connectivity;

  NetworkCubit(this._networkInfo, this._connectivity) : super(NetworkInitial()) {
    _init();
  }

  Future<void> _init() async {
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      // Iterate through the list of ConnectivityResult and update the status
      for (var result in results) {
        _updateConnectionStatus(result);
      }
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      emit(NetworkDisconnected());
    } else {
      await _fetchNetworkInfo();
    }
  }

  Future<void> _fetchNetworkInfo() async {
    String? wifiName, wifiBSSID, wifiIPv4, wifiIPv6, wifiGatewayIP, wifiBroadcast, wifiSubmask;

    // Fetch WiFi Name
    wifiName = await _getWifiName();
    // Fetch WiFi BSSID
    wifiBSSID = await _getWifiBSSID();
    // Fetch WiFi IPv4
    wifiIPv4 = await _getWifiIP();
    // Fetch WiFi IPv6
    wifiIPv6 = await _getWifiIPv6();
    // Fetch WiFi Submask
    wifiSubmask = await _getWifiSubmask();
    // Fetch WiFi Broadcast
    wifiBroadcast = await _getWifiBroadcast();
    // Fetch WiFi Gateway IP
    wifiGatewayIP = await _getWifiGatewayIP();

    emit(NetworkConnected(
      wifiName: wifiName,
      wifiBSSID: wifiBSSID,
      wifiIPv4: wifiIPv4,
      wifiIPv6: wifiIPv6,
      wifiGatewayIP: wifiGatewayIP,
      wifiBroadcast: wifiBroadcast,
      wifiSubmask: wifiSubmask,
    ));
  }

  Future<String?> _getWifiName() async {
    try {
      if (await Permission.locationWhenInUse.request().isGranted) {
        return await _networkInfo.getWifiName();
      } else {
        return 'Unauthorized to get Wifi Name';
      }
    } catch (e) {
      return 'Failed to get Wifi Name';
    }
  }

  Future<String?> _getWifiBSSID() async {
    try {
      if (await Permission.locationWhenInUse.request().isGranted) {
        return await _networkInfo.getWifiBSSID();
      } else {
        return 'Unauthorized to get Wifi BSSID';
      }
    } catch (e) {
      return 'Failed to get Wifi BSSID';
    }
  }

  Future<String?> _getWifiIP() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (e) {
      return 'Failed to get Wifi IPv4';
    }
  }

  Future<String?> _getWifiIPv6() async {
    try {
      return await _networkInfo.getWifiIPv6();
    } catch (e) {
      return 'Failed to get Wifi IPv6';
    }
  }

  Future<String?> _getWifiSubmask() async {
    try {
      return await _networkInfo.getWifiSubmask();
    } catch (e) {
      return 'Failed to get Wifi submask address';
    }
  }

  Future<String?> _getWifiBroadcast() async {
    try {
      return await _networkInfo.getWifiBroadcast();
    } catch (e) {
      return 'Failed to get Wifi broadcast';
    }
  }

  Future<String?> _getWifiGatewayIP() async {
    try {
      return await _networkInfo.getWifiGatewayIP();
    } catch (e) {
      return 'Failed to get Wifi gateway address';
    }
  }
}
