import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:get/get.dart';

class ChatLogic extends GetxController {
  String? groupId;
  UserInfo userInfo = Get.arguments["userInfo"];
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFocusNode = FocusNode();
  List<Message> messageList = [
    Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 1,
      targetId: 7,
      type: 1,
      contentType: MessageType.text,
      content: "我开始学习编程。我觉得这是一个很有用的技能，可以帮助我在工作中更高效地处理任务。",
    ),
    Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),Message(
      sendTime: "2022-01-01 10:00:00",
      formId: 7,
      targetId: 1,
      type: 1,
      contentType: MessageType.text,
      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa🤔",
    ),
  ];
  ScrollController scrollController = ScrollController();

  Future<bool> getHistoryMsgList() async {
    return false;
  }
}
