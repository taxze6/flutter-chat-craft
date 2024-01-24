import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/routes/app_navigator.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../common/apis.dart';
import '../../../models/contact.dart';
import '../../../res/strings.dart';
import '../../../widget/toast_utils.dart';

class NewChatLogic extends GetxController {
  List<UserInfo> users = [];
  late SliverObserverController observerController;
  bool isShowListMode = true;
  ScrollController scrollController = ScrollController();
  List<ContactModel> contactList = <ContactModel>[];
  Map<int, BuildContext> sliverContextMap = {};
  ValueNotifier<CursorInfoModel?> cursorInfo = ValueNotifier(null);
  double indexBarWidth = 20;
  final indexBarContainerKey = GlobalKey();

  List<String> get symbols => contactList.map((e) => e.section).toList();

  @override
  onInit() {
    super.onInit();
    observerController = SliverObserverController(controller: scrollController);
    loadFriends();
  }

  Future<void> loadFriends() async {
    var data = await Apis.getFriends();
    if (data != false) {
      for (var info in data) {
        users.add(UserInfo.fromJson(info));
      }
      generateContactData();
    } else {
      ToastUtils.toastText(StrRes.friendListIsEmpty);
    }
  }

  generateContactData() {
    final a = const Utf8Codec().encode("A").first;
    final z = const Utf8Codec().encode("Z").first;
    int pointer = a;
    while (pointer >= a && pointer <= z) {
      final character = const Utf8Codec().decode(Uint8List.fromList([pointer]));
      List<UserInfo> info = users
          .where((user) =>
              user.userName.toLowerCase().startsWith(character.toLowerCase()))
          .toList();
      if (info.isNotEmpty) {
        contactList.add(
          ContactModel(
            section: character,
            users: info,
          ),
        );
      }
      pointer++;
    }
    update(["cursor", "chatList"]);
  }

  void toMine(UserInfo userInfo) {
    AppNavigator.startMine(isMine: false, userInfo: userInfo);
  }

  void startNewChat() {
    AppNavigator.startNewChat();
  }
}
