import 'package:chat/src/config/constant/assets.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/utils/post_frame_callback_mixin.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with PostFrameCallbackMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.assetsImagesAppIcon,
          height: 50.w,
        ),
      ),
    );
  }

  @override
  void onPostFrameCallback() async {
    final router = GoRouter.of(context);
    final authenticationProvider = context.read<AuthenticationProvider>();
    await Future.delayed(const Duration(seconds: 2));
    bool isLogin = await authenticationProvider.checkIsLogin();
    if (isLogin) {
      router.go(Routes.dashboard);
    } else {
      router.go(Routes.login);
    }
  }
}
