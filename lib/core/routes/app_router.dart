

import 'package:bleutooth_with_esp8266/features/bluetooth_connectivity/presentation/views/show_bluetooth_available_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/views/home_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
static const kHomeView ="/homeView";
static const kShowBluetoothAvailableView ="/showBluetoothAvailableView";
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
        path: kShowBluetoothAvailableView,
        builder: (context, state) =>const ShowBluetoothAvailableView(),
      ),
      
    ],
  );
}
