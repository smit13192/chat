
import 'package:chat/src/core/screens/no_page_found_screen.dart';
import 'package:chat/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:chat/src/feature/auth/presentation/screen/register_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/get_all_user_chat_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/home_screen.dart';
import 'package:chat/src/feature/splash/splash_screen.dart';
import 'package:flutter/material.dart';

part 'routes.dart';

typedef RouteBuilder = Widget Function(Object? arguments);

class RouteModel {
  String name;
  RouteBuilder builder;

  RouteModel({
    required this.name,
    required this.builder,
  });
}

abstract class AppRouter {
  static RouteModel noPageFoundRoute = RouteModel(
    name: Routes.noPageFound,
    builder: (arguments) => const NoPageFoundScreen(),
  );

  static const String initialRoute = Routes.splash;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    String? name = settings.name;
    final route = routes.firstWhere(
      (element) => element.name == name,
      orElse: () => noPageFoundRoute,
    );
    Object? arguments = settings.arguments;
    return MaterialPageRoute(builder: (context) => route.builder(arguments));
  }

  static List<RouteModel> routes = [
    RouteModel(
      name: Routes.splash,
      builder: (arguments) => const SplashScreen(),
    ),
    RouteModel(
      name: Routes.login,
      builder: (arguments) => const LoginScreen(),
    ),
    RouteModel(
      name: Routes.register,
      builder: (arguments) => const RegisterScreen(),
    ),
    RouteModel(
      name: Routes.home,
      builder: (arguments) => const HomeScreen(),
    ),
    RouteModel(
      name: Routes.chat,
      builder: (arguments) =>
          ChatScreen(params: (arguments as ChatScreenParmas)),
    ),
    RouteModel(
      name: Routes.getAllUserChat,
      builder: (arguments) => const GetAllUserChatScreen(),
    ),
  ];
}