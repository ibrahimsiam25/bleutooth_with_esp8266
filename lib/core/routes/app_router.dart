

import 'package:bleutooth_with_esp8266/features/home/data/model/wifi_credentials.dart';
import 'package:go_router/go_router.dart';

import '../../features/bluetooth_connectivity/presentation/views/bluetooth_connect_view_body_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
static const kHomeView ="/homeView";
static const kBluetoothConnectView ="/BluetoothConnectView";
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) =>const SplashView(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) =>const HomeView(),
      ),
      GoRoute(
        path: kBluetoothConnectView,
        builder: (context, state) => BluetoothConnectView(
          wifiCredentials: state.extra as WifiCredentials
        ,),
      ),
      
    ],
  );
}
