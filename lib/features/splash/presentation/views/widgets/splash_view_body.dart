import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/routes/app_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    executeNavigation();
    super.initState();
  }

  void executeNavigation() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        // ignore: use_build_context_synchronously
        GoRouter.of(context).go(AppRouter.kHomeView);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: AspectRatio(
          aspectRatio: 7974 / 7521,
          child: SvgPicture.asset(AppAssets.ropot),
        ),
      ),
    );
  }
}
