import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:get/get.dart';

import '../../../common/apis.dart';

class ChatLogic extends GetxController {
  String? groupId;
  UserInfo userInfo = Get.arguments["userInfo"];
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFocusNode = FocusNode();
  List<Message> messageList = [];
  ScrollController scrollController = ScrollController();

  int chatStart = 0;
  int chatEnd = 30;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> getHistoryMsgList() async {
    var data = await Apis.getRedisMsg(
        targetId: userInfo.userID, start: chatStart, end: chatEnd, isRev: true);
    if (data == false) {
      return false;
    } else {
      for (var info in data) {
        Message message = Message.fromJson(json.decode(info));
        messageList.add(message);
        print(message.toString());
      }
      update(["chatList"]);
    }
    return false;
  }

  test() {}
}
