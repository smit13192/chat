part of 'router.dart';

enum Routes {
  splash('/splash'),
  login('/login'),
  register('/register'),
  dashboard('/'),
  chat('/chat'),
  editProfile('/edit-profile');

  final String path;
  const Routes(this.path);

  static List<String> get privateRoutes => [
    dashboard.path,
    chat.path,
    editProfile.path,
  ];
}
