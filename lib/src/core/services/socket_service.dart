import 'dart:async';

import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/services/network_service.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketListner extends Equatable {
  final String event;
  final void Function(Object? data) listner;

  const SocketListner({
    required this.event,
    required this.listner,
  });

  @override
  List<Object?> get props => [event];
}

class SocketEmitter extends Equatable {
  final String event;
  final Object Function() callBack;

  const SocketEmitter({
    required this.event,
    required this.callBack,
  });

  @override
  List<Object?> get props => [event];
}

class SocketService {
  Socket? _socket;
  StreamSubscription<bool>? _internetSubscription;

  NetworkService networkService = NetworkService.instance;

  SocketService._();

  void socketInit() {
    disconnect();
    final token = Storage.instance.getToken();
    _socket = io(
      Endpoints.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({
            'Authorization': 'Bearer $token',
          })
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );
    _socket?.connect();

    _internetSubscription = NetworkService.instance.internetStream.listen(
      (event) {
        if (event && _socket?.disconnected == true) {
          _socket?.connect();
          for (SocketListner listner in listners) {
            _socket?.on(listner.event, listner.listner);
          }
          for (SocketEmitter emmiter in emitters) {
            _socket?.emit(emmiter.event, emmiter.callBack());
          }
        } else if (!event && _socket?.connected == true) {
          _socket?.disconnect();
        }
      },
    );
  }

  static SocketService instance = SocketService._();

  Set<SocketListner> listners = {};
  Set<SocketEmitter> emitters = {};

  void emit(String event, [Object? argument]) {
    if (_socket?.disconnected == true) {
      _socket?.connect();
    }
    _socket?.emit(event, argument);
  }

  void addEmitter(SocketEmitter emitter) {
    if (_socket?.disconnected == true) {
      _socket?.connect();
    }
    emitters.add(emitter);
    emit(emitter.event, emitter.callBack());
  }

  void add(SocketListner listner) {
    if (_socket?.disconnected == true) {
      _socket?.connect();
    }
    listners.add(listner);
    _socket?.on(listner.event, listner.listner);
  }

  void disconnect() {
    if (_socket?.connected == true) {
      _socket?.disconnect();
      _socket = null;
      _internetSubscription?.cancel();
      emitters.clear();
      listners.clear();
    }
  }
}
