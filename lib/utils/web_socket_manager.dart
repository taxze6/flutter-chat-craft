import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../common/global_data.dart';
import '../common/urls.dart';
import '../models/message.dart';

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

  ///Heartbeat Timer
  Timer? _heartBeat;

  ///Heartbeat Interval (in milliseconds)
  final int _heartTimes = 30000;

  ///Maximum number of reconnections,Default value is 10
  final int _reconnectCount = 10;

  ///Reconnection Counter
  int _reconnectTimes = 0;

  ///Reconnection timer.
  Timer? _reconnectTimer;

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
      if (_reconnectTimes == 0) {
        print("第一次socket连接成功");
      } else {
        print("重连成功");
      }
      _reconnectTimes = 0;
      if (_reconnectTimer != null) {
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      }
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
    print("----------------------------");
    if (_reconnectTimes < _reconnectCount) {
      _reconnectTimes++;
      print("开始重连，这是第$_reconnectTimes次重连");
      _reconnectTimer =
          Timer.periodic(Duration(milliseconds: _heartTimes), (timer) async {
        await disconnect();
        await connect(url);
      });
    } else {
      if (_reconnectTimer != null) {
        print("The reconnection attempts have exceeded the maximum limit.");
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      }
      return;
    }
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
    }, onDone: () {
      print("123");
      reconnect(Urls.sendUserMsg);
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

  /// Init Heart
  void initHeartBeat() {
    destroyHeartBeat();
    _heartBeat = Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
      sentHeart();
    });
  }

  /// Heart
  void sentHeart() {
    var msg = Message.fromHeartbeat();
    sendMsg(msg.toJsonString());
  }

  /// disposeHeart
  void destroyHeartBeat() {
    if (_heartBeat != null) {
      _heartBeat?.cancel();
      _heartBeat = null;
    }
  }

  /// Destroy the channel.
  void dispose() {
    //Disconnect the connection.
    disconnect();
    //Close the flow of the connection status.
    _socketStatusController.close();
  }
}
