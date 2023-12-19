import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../common/global_data.dart';

enum ConnectStatusEnum { connect, connecting, close, closing }

typedef ListenMessageCallback = void Function(String msg);

typedef ErrorCallback = void Function(Exception error);

/// WebSocketManager
class WebSocketManager {
  ///ConnectStatus The default connection status is closed.
  ConnectStatusEnum _connectStatus = ConnectStatusEnum.close;

  ///channel
  WebSocketChannel? _webSocketChannel;

  /// WebSocket Channel Stream
  Stream<dynamic>? _webSocketChannelStream;

  /// WebSocket Status Controller
  final StreamController<ConnectStatusEnum> _socketStatusController =
      StreamController<ConnectStatusEnum>();

  /// The flow of the connection status.
  Stream<ConnectStatusEnum>? _socketStatusStream;

  /// The flow of obtaining WebSocket messages.
  Stream<dynamic> getWebSocketChannelStream() {
    //Assign the value only once.
    _webSocketChannelStream ??= _webSocketChannel!.stream.asBroadcastStream();
    return _webSocketChannelStream!;
  }

  /// The flow of obtaining the connection status.
  Stream<ConnectStatusEnum> getSocketStatusStream() {
    //Assign the value only once.
    _socketStatusStream ??= _socketStatusController.stream.asBroadcastStream();
    return _socketStatusStream!;
  }

  /// connect
  Future<bool> connect(String url) async {
    if (_connectStatus == ConnectStatusEnum.connect) {
      //Connected, no further processing required.
      return true;
    } else if (_connectStatus == ConnectStatusEnum.close) {
      //Not connected, initiate the connection.
      _connectStatus = ConnectStatusEnum.connecting;
      _socketStatusController.add(ConnectStatusEnum.connecting);
      var connectUrl = Uri.parse(url);
      //The Channel needs to be used on the web end, otherwise an error will occur.
      if (kIsWeb) {
        _webSocketChannel = WebSocketChannel.connect(connectUrl);
      } else {
        _webSocketChannel = IOWebSocketChannel.connect(
          connectUrl,
          headers: {
            "Authorization": GlobalData.token,
            "UserId": GlobalData.userInfo.userID,
          },
        );
      }
      _connectStatus = ConnectStatusEnum.connect;
      _socketStatusController.add(ConnectStatusEnum.connect);
      return true;
    } else {
      return false;
    }
  }

  /// Close the connection.
  Future disconnect() async {
    if (_connectStatus == ConnectStatusEnum.connect) {
      _connectStatus = ConnectStatusEnum.closing;
      if (!_socketStatusController.isClosed) {
        _socketStatusController.add(ConnectStatusEnum.closing);
      }
      await _webSocketChannel?.sink
          .close(3000, "Close the connection actively.");
      _connectStatus = ConnectStatusEnum.close;
      if (!_socketStatusController.isClosed) {
        _socketStatusController.add(ConnectStatusEnum.close);
      }
    }
  }

  /// Reconnect
  void reconnect(String url) async {
    await disconnect();
    await connect(url);
  }

  /// Listen for messages
  void listen(ListenMessageCallback messageCallback, {ErrorCallback? onError}) {
    getWebSocketChannelStream().listen((message) {
      messageCallback.call(message);
    }, onError: (error) {
      //Connection exception
      _connectStatus = ConnectStatusEnum.close;
      _socketStatusController.add(ConnectStatusEnum.close);
      if (onError != null) {
        onError.call(error);
      }
    });
  }

  /// Send a message
  bool sendMsg(String text) {
    if (_connectStatus == ConnectStatusEnum.connect) {
      _webSocketChannel?.sink.add(text);
      return true;
    }
    return false;
  }

  /// Get the current connection status.
  ConnectStatusEnum getCurrentStatus() {
    if (_connectStatus == ConnectStatusEnum.connect) {
      return ConnectStatusEnum.connect;
    } else if (_connectStatus == ConnectStatusEnum.connecting) {
      return ConnectStatusEnum.connecting;
    } else if (_connectStatus == ConnectStatusEnum.close) {
      return ConnectStatusEnum.close;
    } else if (_connectStatus == ConnectStatusEnum.closing) {
      return ConnectStatusEnum.closing;
    }
    return ConnectStatusEnum.closing;
  }

  /// Destroy the channel.
  void dispose() {
    //Disconnect the connection.
    disconnect();
    //Close the flow of the connection status.
    _socketStatusController.close();
  }
}
