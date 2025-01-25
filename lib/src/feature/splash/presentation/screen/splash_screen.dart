import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/utils/post_frame_callback_mixin.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:chat/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with PostFrameCallbackMixin {
  @override
  Widget build(BuildContext context) {
    final authenticationProvider = context.watch<AuthenticationProvider>();
    if (authenticationProvider.user != null) {
      return const DashboardScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  void onPostFrameCallback() async {
    final router = GoRouter.of(context);
    final authenticationProvider = context.read<AuthenticationProvider>();
    await Future.delayed(const Duration(seconds: 2));
    bool isLogin = await authenticationProvider.checkIsLogin();
    if (isLogin) {
      router.goNamed(Routes.dashboard.name);
    } else {
      router.goNamed(Routes.login.name);
    }
  }
}
