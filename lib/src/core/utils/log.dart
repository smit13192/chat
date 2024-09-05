import 'dart:developer';

import 'package:flutter/foundation.dart';

class Log {
  static void d(dynamic data) {
    if (kDebugMode) {
      log('$data', name: 'INFO');
    }
  }

  static void e(dynamic data) {
    if (kDebugMode) {
      log('$data', name: 'ERROR');
    }
  }

  static void s(dynamic data) {
    if (kDebugMode) {
      log('$data', name: 'SUCCESS');
    }
  }
}
