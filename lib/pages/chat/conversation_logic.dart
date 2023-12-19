import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/urls.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../common/apis.dart';
import '../../common/global_data.dart';
import '../../models/user_info.dart';
import '../../utils/web_socket_manager.dart';
import '../../widget/loading_view.dart';

class ConversationLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  String appText = StrRes.chatCraft;
  final refreshController = RefreshController(initialRefresh: false);
  List<UserInfo> friendsInfo = [];
  final WebSocketManager webSocketManager = WebSocketManager();
  late Timer heartBeatTimer;
  RxList<ConversationInfo> conversationsInfo = <ConversationInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingView.singleton.wrap(
        asyncFunction: loadFriends,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadFriends() async {
    var data = await Apis.getFriends();
    if (data != false) {
      for (var info in data) {
        friendsInfo.add(UserInfo.fromJson(info));
      }
      initWebSocket();
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
    webSocketManager.connect(Urls.sendUserMsg).then((isConnect) {
      //连接成功，监听消息
      if (isConnect) {
        webSocketManager.listen((msg) {
          //添加消息到列表中
          print('Received: $msg');
          onMessage(
            Message.fromJson(
              json.decode(msg),
            ),
          );
        }, onError: (error) {
          ToastUtils.toastText(error.toString());
        });
      }
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

  void heartbeat() {
    var msg = Message.fromHeartbeat();
    webSocketManager.sendMsg(msg.toJsonString());
  }

  // void testMessage() {
  //   var msg = Message(
  //     targetId: friendsInfo[0].userID,
  //     type: ConversationType.single,
  //     formId: GlobalData.userInfo.userID,
  //     contentType: MessageType.text,
  //     content: "测试数据111",
  //   );
  //   webSocketManager.sendMsg(msg.toJsonString());
  // }

  void onMessage(Message message) {
    print("userID${friendsInfo[0].userID}");
    print("formId${message.formId}");
    print("targetId${message.targetId}");
    UserInfo userInfo = friendsInfo.firstWhere(
      (element) => element.userID == message.formId,
    );
    String content = "";
    if (message.contentType == MessageType.text) {
      content = message.content ?? "";
    } else if (message.contentType == MessageType.picture) {
      content = "[${StrRes.picture}]";
    } else if (message.contentType == MessageType.video) {
      content = "[${StrRes.video}]";
    } else if (message.contentType == MessageType.voice) {
      content = "[${StrRes.voice}]";
    }

    ConversationInfo info = ConversationInfo(
      userInfo: userInfo,
      message: message,
      previewText: content,
    );
    bool containsValue =
        conversationsInfo.any((info) => info.userInfo.userID == message.formId);
    if (containsValue) {
      int index = conversationsInfo
          .indexWhere((info) => info.userInfo.userID == message.formId);
      conversationsInfo[index] = info;
    } else {
      conversationsInfo.add(info);
    }
  }

  /// Determine the top.
  bool isPinned(int index) {
    return false;
  }
}
