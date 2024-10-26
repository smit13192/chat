import 'package:chat/app/app_provider.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/constant/app_string.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sizer/sizer.dart';

class App extends StatefulWidget {
  final Widget home;
  const App({super.key, required this.home});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: AppString.appName,
            debugShowCheckedModeBanner: false,
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              overscroll: false,
              physics: const ClampingScrollPhysics(),
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            theme: ThemeData(
              fontFamily: AppString.fontFamily,
              scaffoldBackgroundColor: AppColor.scaffoldColor,
              useMaterial3: false,
              primaryColor: AppColor.primaryColor,
              primarySwatch: AppMaterialColor.primaryColor,
            ),
            home: widget.home,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
