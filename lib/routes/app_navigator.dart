import 'dart:async';

import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

typedef CheckCodeMethod = Future<bool> Function(String code);

abstract class AppNavigator {
  static void startLogin() {
    Get.toNamed(AppRoutes.login);
  }

  static void startLoginEmail() {
    Get.toNamed(AppRoutes.loginEmail);
  }

  static void startRegister() {
    Get.toNamed(AppRoutes.register);
  }

  static Future<bool> startCheckCode({
    required String email,
    required Function() regainVerifyCode,
    required CheckCodeMethod checkCodeMethod,
  }) {
    Completer<bool> completer = Completer<bool>();
    Get.toNamed(AppRoutes.checkCode, arguments: {
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
    int? groupId,
  }) {
    Get.toNamed(AppRoutes.chat, arguments: {
      'userInfo': userInfo,
      'groupId': groupId,
    });
  }
}
