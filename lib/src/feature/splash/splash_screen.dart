import 'dart:async';

import 'package:chat/src/config/constant/assets.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween(begin: 0.0, end: 150.0).animate(animationController);
    animationController.forward();
    goToNext();
  }

  void goToNext() {
    Timer(
      const Duration(seconds: 2),
      () {
        context.read<AuthenticationProvider>().checkIsLogin(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Image.asset(
              Assets.assetsImagesAppIcon,
              height: animation.value,
            );
          },
        ),
      ),
    );
  }
}
