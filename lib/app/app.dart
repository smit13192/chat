import 'package:chat/app/app_provider.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/constant/app_string.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: AppString.appName,
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              overscroll: false,
              physics: const ClampingScrollPhysics(),
            ),
            theme: ThemeData(
              fontFamily: GoogleFonts.lato().fontFamily,
              textTheme: GoogleFonts.latoTextTheme(),
              scaffoldBackgroundColor: AppColor.scaffoldColor,
              useMaterial3: false,
              primaryColor: AppColor.primaryColor,
              primarySwatch: AppMaterialColor.primaryColor,
            ),
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
