import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/urls.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
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
    } else {
      ToastUtils.toastText(StrRes.friendListIsEmpty);
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
      if (isConnect) {
        webSocketManager.listen((msg) {
          print('Received: $msg');
          Message data = Message.fromJson(
            json.decode(msg),
          );
          if (data.msgId == "-1") {
            //It's heart message;
          } else {
            onMessage(data);
          }
          //The server returns a message
        }, onError: (error) {
          ToastUtils.toastText(error.toString());
        });
      }
    });

    webSocketManager.initHeartBeat();
    // test();
  }

  void heartbeat() {}

  // void test() {
  //   int count = 0;
  //
  //   // 创建定时器，每隔 100 毫秒执行一次 testMessage() 函数
  //   Timer.periodic(Duration(milliseconds: 50), (timer) {
  //     testMessage(count);
  //     count++;
  //
  //     // 循环执行 1 万次后，取消定时器
  //     if (count == 500) {
  //       timer.cancel();
  //     }
  //   });
  // }
  //
  // void testMessage(int index) {
  //   var message = Message(
  //     msgId: generateMessageId(friendsInfo[0].userID),
  //     targetId: friendsInfo[0].userID,
  //     type: ConversationType.single,
  //     formId: GlobalData.userInfo.userID,
  //     contentType: MessageType.text,
  //     content: "test$index",
  //     sendTime: DateTime.now().toString(),
  //     status: MessageStatus.sending,
  //   );
  //   webSocketManager.sendMsg(message);
  // }

  void onMessage(Message message) {
    bool self = false;
    if (message.formId == GlobalData.userInfo.userID) {
      self = true;
    }

    UserInfo userInfo = friendsInfo.firstWhere(
      (element) => element.userID == (self ? message.targetId : message.formId),
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
    bool containsValue = conversationsInfo.any((info) =>
        info.userInfo.userID == (self ? message.targetId : message.formId));
    if (containsValue) {
      int index = conversationsInfo.indexWhere((info) =>
          info.userInfo.userID == (self ? message.targetId : message.formId));
      conversationsInfo[index] = info;
    } else {
      conversationsInfo.add(info);
    }
  }

  void toChat(int index) {
    AppNavigator.startChat(userInfo: conversationsInfo[index].userInfo);
  }

  /// Determine the top.
  bool isPinned(int index) {
    return false;
  }

  void startUserInfo(UserInfo userInfo) {
    AppNavigator.startMine(isMine: false, userInfo: userInfo);
  }
}
