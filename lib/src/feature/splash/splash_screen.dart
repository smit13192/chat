import 'dart:async';


import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/constant/app_string.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation =
        Tween<double>(begin: 0.0.sp, end: 40.0.sp).animate(animationController);
    animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    goToNext();
  }

  void goToNext() {
    Timer(
      const Duration(seconds: 1),
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
            return CustomText(
              AppString.appName.toUpperCase(),
              fontSize: animation.value,
              color: AppColor.whiteColor,
            );
          },
        ),
      ),
    );
  }
}
