import 'dart:async';

import 'package:chat/src/core/utils/log.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class NetworkService {
  bool _isInternetAvailable = false;
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _internetStream = StreamController.broadcast();

  Stream<bool> get internetStream => _internetStream.stream;
  bool get isInternetAvailable => _isInternetAvailable;

  static final NetworkService instance = NetworkService._();

  NetworkService._() {
    init();
  }

  late StreamSubscription<List<ConnectivityResult>> streamSubscription;

  void init() async {
    try {
      List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        _internetStream.sink.add(true);
        _isInternetAvailable = true;
      } else {
        _isInternetAvailable = false;
        _internetStream.sink.add(false);
      }
    } on PlatformException catch (e) {
      Log.e('Network Service File Error ${e.message}');
    }
    streamSubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  void dispose() {
    streamSubscription.cancel();
  }

  void updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      if (_isInternetAvailable) return;
      _internetStream.sink.add(true);
      _isInternetAvailable = true;
    } else {
      _internetStream.sink.add(false);
      _isInternetAvailable = false;
    }
  }
}
