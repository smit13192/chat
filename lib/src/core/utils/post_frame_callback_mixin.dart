import 'package:flutter/material.dart';

mixin PostFrameCallbackMixin<T extends StatefulWidget> on State<T> {
  void onPostFrameCallback();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onPostFrameCallback();
    });
  }
}
