import 'package:chat/locator.dart';
import 'package:chat/src/core/screens/no_page_found_screen.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:chat/src/feature/auth/presentation/screen/edit_profile_screen.dart';
import 'package:chat/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:chat/src/feature/auth/presentation/screen/register_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/dashboard_screen.dart';
import 'package:chat/src/feature/splash/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.dart';

class AppRouterNavigationKey {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: AppRouterNavigationKey.navigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) => ChatScreen(
          params: state.extra as ChatScreenParmas,
        ),
      ),
    ],
    errorBuilder: (context, state) => const NoPageFoundScreen(),
    redirect: (context, state) {
      final authProvider = locator<AuthenticationProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      if (Routes.privateRoutes.contains(state.matchedLocation) &&
          !isAuthenticated) {
        return Routes.login;
      }
      if (state.matchedLocation == Routes.login && isAuthenticated) {
        return Routes.dashboard;
      }
      return null;
    },
  );
}
