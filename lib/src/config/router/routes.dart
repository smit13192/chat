part of 'router.dart';

abstract class Routes {
  static const String splashScreen = '/';
  static const String register = 'register';
  static const String chat = 'chat';
  static const String editProfile = 'edit-profile';

  static List<String> get privateRoutes => [
        '/$chat',
        '/$editProfile',
      ];
}
