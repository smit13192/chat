import 'package:chat/app/app.dart';
import 'package:chat/locator.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:chat/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

final systemOverlayStyle = SystemUiOverlayStyle.light.copyWith(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
);

Future<void> boxOpen() async {
  await Hive.openBox(StorageString.mainAppBoxName);
}

Future<void> init() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(systemOverlayStyle);
  await Hive.initFlutter();
  await boxOpen();
  initLocator();
}

Future<void> main(List<String> args) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  bool isLogin = await locator<AuthenticationProvider>().checkIsLogin();
  runApp(App(home: isLogin ? const DashboardScreen() : const LoginScreen()));
}
