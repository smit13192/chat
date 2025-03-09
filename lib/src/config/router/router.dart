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
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: AppRouterNavigationKey.navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: Routes.splash.path,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.dashboard.path,
        name: Routes.dashboard.name,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: Routes.editProfile.path,
        name: Routes.editProfile.name,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.chat.path,
        name: Routes.chat.name,
        builder: (context, state) {
          return ChatScreen(params: state.extra as ChatScreenParmas);
        },
      ),
    ],
    errorBuilder: (context, state) => const NoPageFoundScreen(),
    redirect: (context, state) {
      final authProvider = locator<AuthenticationProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      if (Routes.privateRoutes.contains(state.matchedLocation) &&
          !isAuthenticated) {
        return Routes.login.path;
      }
      if (state.matchedLocation == Routes.login.path && isAuthenticated) {
        return Routes.dashboard.path;
      }
      return null;
    },
  );
}
