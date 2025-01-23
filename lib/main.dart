import 'dart:async';

import 'package:chat/app/app.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/locator.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

final systemOverlayStyle = SystemUiOverlayStyle.light.copyWith(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
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
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  await Hive.initFlutter();
  await boxOpen();
  initLocator();
}

Future<void> main(List<String> args) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  runApp(const App());
}
