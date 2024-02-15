import 'dart:async';

import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/pages/mine/mine_logic.dart';
import 'package:flutter_chat_craft/pages/mine/mine_view.dart';
import 'package:get/get.dart';

import '../models/user_story.dart';
import 'app_routes.dart';

typedef CheckCodeMethod = Future<bool> Function(String code);

abstract class AppNavigator {
  static void startLogin() {
    Get.toNamed(AppRoutes.login);
  }

  static void logout() {
    Get.offAllNamed(AppRoutes.login);
  }

  static void startLoginEmail() {
    Get.toNamed(AppRoutes.loginEmail);
  }

  static void startRegister() {
    Get.toNamed(AppRoutes.register);
  }

  static Future<bool> startCheckCode({
    required String name,
    required String email,
    required Function() regainVerifyCode,
    required CheckCodeMethod checkCodeMethod,
  }) {
    Completer<bool> completer = Completer<bool>();
    Get.toNamed(AppRoutes.checkCode, arguments: {
      'name': name,
      'email': email,
      'regainVerifyCode': regainVerifyCode,
      'checkCodeMethod': checkCodeMethod,
    })!
        .then((value) {
      completer.complete(value);
    });
    return completer.future;
  }

  static void startHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  static void startAddFriend() {
    Get.toNamed(AppRoutes.addFriend);
  }

  static void startChat({
    UserInfo? userInfo,
    int groupId = 0,
  }) {
    Get.toNamed(AppRoutes.chat, arguments: {
      'userInfo': userInfo,
      'groupId': groupId,
    });
  }

  static void startMine({
    required bool isMine,
    UserInfo? userInfo,
  }) {
    Get.dialog(GetBuilder<MineLogic>(
      init: MineLogic(),
      builder: (controller) {
        if (isMine) {
          controller.setUserInfo(GlobalData.userInfo);
        } else {
          controller.setUserInfo(userInfo!);
        }
        return MinePage(controller: controller);
      },
    ));
  }

  static void startMineStoryDetails({
    required UserInfo userInfo,
    required UserStory userStory,
  }) {
    Get.toNamed(AppRoutes.mineStoryDetails, arguments: {
      'userInfo': userInfo,
      'userStory': userStory,
    });
  }

  static void startNewChat() {
    Get.toNamed(AppRoutes.newChat);
  }

  static void startInvite({
    required String email,
    required String name,
  }) {
    Get.toNamed(AppRoutes.invite, arguments: {'email': email, 'name': name});
  }
}
