part of 'router.dart';

abstract class Routes {
  static const String splashScreen = '/';
  static const String noPageFound = '/no-page-found';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String chat = '/chat';
  static const String editProfile = '/edit-profile';

  static List<String> get privateRoutes => [
        dashboard,
        chat,
        editProfile,
      ];
}
