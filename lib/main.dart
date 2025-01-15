import 'package:chat/app/app.dart';
import 'package:chat/locator.dart';
import 'package:chat/src/core/database/storage.dart';
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
  runApp(const App());
}
