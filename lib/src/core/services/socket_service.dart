import 'package:chat/src/api/endpoints.dart';
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
  late Socket _socket;

  NetworkService networkService = NetworkService.instance;

  SocketService._() {
    _socket = io(
      Endpoints.baseUrl,
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    NetworkService.instance.internetStream.listen(
      (event) {
        if (event && _socket.disconnected) {
          _socket.connect();
          for (SocketListner listner in listners) {
            _socket.on(listner.event, listner.listner);
          }
          for (SocketEmitter emmiter in emitters) {
            _socket.emit(emmiter.event, emmiter.callBack());
          }
        } else if (!event && _socket.connected) {
          _socket.disconnect();
        }
      },
    );
    _socket.connect();
  }

  static SocketService instance = SocketService._();

  Set<SocketListner> listners = {};
  Set<SocketEmitter> emitters = {};

  void emit(String event, [Object? argument]) {
    if (_socket.disconnected) {
      _socket.connect();
    }
    _socket.emit(event, argument);
  }

  void addEmitter(SocketEmitter emitter) {
    if (_socket.disconnected) {
      _socket.connect();
    }
    emitters.add(emitter);
    emit(emitter.event, emitter.callBack());
  }

  void add(SocketListner listner) {
    if (_socket.disconnected) {
      _socket.connect();
    }
    listners.add(listner);
    _socket.on(listner.event, listner.listner);
  }

  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }
}
