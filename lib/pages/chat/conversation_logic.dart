import 'dart:async';

import 'package:flutter_chat_craft/common/urls.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../common/apis.dart';
import '../../common/global_data.dart';
import '../../models/user_info.dart';
import '../../widget/loading_view.dart';

class ConversationLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  String appText = StrRes.chatCraft;
  final refreshController = RefreshController(initialRefresh: false);
  List<UserInfo> friendsInfo = [];
  late IOWebSocketChannel socketChannel;
  late Timer heartBeatTimer;
  List<ConversationInfo> conversationInfo = [];

  @override
  void onInit() {
    super.onInit();
    loadFriends();
    initWebSocket();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadFriends() async {
    var data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.getFriends(),
    );
    if (data != false) {
      for (var info in data) {
        friendsInfo.add(UserInfo.fromJson(info));
      }
      update(["friendList"]);
    }
  }

  void onRefresh() async {
    var list = [];
    try {
      // list = await _request(0);
      // this.list..assignAll(list);
      // print("fetch onRefresh ${this.list.length}");
      //
      // if (null == list || list.isEmpty || list.length < _pageSize) {
      //   refreshController.loadNoData();
      // }
      Future.delayed(Duration(seconds: 3), () {
        refreshController.loadNoData();
      });
    } finally {
      refreshController.refreshCompleted();
    }
  }

  void onLoading() async {
    var list = [];
    try {
      // list = await _request(this.list.length);
      // this.list..addAll(list);
      // print("fetch onLoading ${this.list.length}");
      Future.delayed(Duration(seconds: 3), () {
        // refreshController.loadNoData();
        refreshController.loadComplete();
      });
    } finally {
      // if (null == list || list.isEmpty || list.length < _pageSize) {
      //   refreshController.loadNoData();
      // } else {
      //   refreshController.loadComplete();
      // }
    }
  }

  Future<void> initWebSocket() async {
    socketChannel = IOWebSocketChannel.connect(
      Urls.sendUserMsg,
      headers: {
        "Authorization": GlobalData.token,
        "UserId": GlobalData.userInfo.userID,
      },
    );

    socketChannel.stream.listen((message) {
      print('Received: $message');
      // channel.sink.close(status.goingAway);
    });
    heartBeatTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      heartbeat();
    });
    // socketChannel.sink.add({
    //   "userId": 9,
    //   "targetId": 10,
    //   "type": ConversationType.single,
    //   "content": "This is a test message"
    // });
  }

  heartbeat() {
    var msg = Message.fromHeartbeat();
    socketChannel.sink.add(msg.toJsonString());
  }

  /// Determine the top.
  bool isPinned(int index) {
    return false;
  }
}
