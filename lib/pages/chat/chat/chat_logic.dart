import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_logic.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';
import '../../../common/global_data.dart';
import '../../../widget/toast_utils.dart';

class ChatLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  String? groupId;
  UserInfo userInfo = Get.arguments["userInfo"];
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFocusNode = FocusNode();
  List<Message> messageList = [];
  ScrollController scrollController = ScrollController();

  int chatStart = 0;
  int chatEnd = 30;
  int chatListSize = 30;

  @override
  void onInit() {
    super.onInit();
    messageAddListen();
  }

  void messageAddListen() {
    conversationLogic.webSocketManager.listen((msg) {
      //Add message to the list.
      Message message = Message.fromJson(
        json.decode(msg),
      );
      print('Received: ${message.toString()}');
      if (message.formId == userInfo.userID) {
        messageList.insert(0, message);
        update(["chatList"]);
      }
    }, onError: (error) {
      ToastUtils.toastText(error.toString());
    });
  }

  void sendMessage() {
    var message = Message(
      targetId: userInfo.userID,
      type: ConversationType.single,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.text,
      content: textEditingController.text,
    );
    bool isSendSuccess =
        conversationLogic.webSocketManager.sendMsg(message.toJsonString());
    if (isSendSuccess) {
      messageList.insert(0, message);
      textEditingController.clear();
      update(["chatList"]);
      scrollBottom();
    }
  }

  Future<bool> getHistoryMsgList() async {
    var data = await Apis.getRedisMsg(
        targetId: userInfo.userID,
        start: chatStart,
        end: chatEnd,
        isRev: false);
    if (data == false) {
      return false;
    } else {
      for (var info in data) {
        Message message = Message.fromJson(json.decode(info));
        messageList.add(message);
        print(message.toString());
      }
      chatStart = chatEnd;
      chatEnd += chatListSize;
      update(["chatList"]);
    }
    return false;
  }

  void scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }
}
