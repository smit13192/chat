import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color primaryColor = Color(0xFF3B3BFF);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color redColor = Colors.red;
  static const Color greenColor = Colors.green;
  static const Color scaffoldColor = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color buttonSplashColor = Colors.black12;
}

abstract class AppMaterialColor {
  static const MaterialColor primaryColor =
      MaterialColor(_primaryColorPrimaryValue, <int, Color>{
    50: Color(0xFFE7E7FF),
    100: Color(0xFFC4C4FF),
    200: Color(0xFF9D9DFF),
    300: Color(0xFF7676FF),
    400: Color(0xFF5858FF),
    500: Color(_primaryColorPrimaryValue),
    600: Color(0xFF3535FF),
    700: Color(0xFF2D2DFF),
    800: Color(0xFF2626FF),
    900: Color(0xFF1919FF),
  });
  static const int _primaryColorPrimaryValue = 0xFF3B3BFF;

  static const MaterialColor primaryColorAccent =
      MaterialColor(_primaryColorAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_primaryColorAccentValue),
    400: Color(0xFFCACAFF),
    700: Color(0xFFB1B1FF),
  });
  static const int _primaryColorAccentValue = 0xFFFDFDFF;
}
