import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/core/services/network_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketListner {
  String event;
  void Function(Object? data) listner;

  SocketListner({
    required this.event,
    required this.listner,
  });
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
        } else if (!event && _socket.connected) {
          _socket.disconnect();
        }
      },
    );
    _socket.connect();
  }

  static SocketService instance = SocketService._();

  List<SocketListner> listners = [];

  void emit(String event, [Object? argument]) {
    if (_socket.disconnected) {
      _socket.connect();
    }
    _socket.emit(event, argument);
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
