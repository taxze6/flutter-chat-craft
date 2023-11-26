import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lang/en_US.dart';
import 'lang/zh_CN.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'zh_CN': zh_CN,
      };
}

class StrRes {
  static get welcomeUse => 'welcomeUse'.tr;

  static get welcomeUseContent => 'welcomeUseContent'.tr;

  static get contactMe => 'contactMe'.tr;

  static get enterChatCraft => 'enterChatCraft'.tr;

  static get login => 'login'.tr;

  static get loginContent => 'loginContent'.tr;

  static get username => 'username'.tr;

  static get usernameInputHintText => 'usernameInputHintText'.tr;

  static get password => 'password'.tr;

  static get passwordInputHintText => 'passwordInputHintText'.tr;

  static get forgetPassword => "forgetPassword".tr;

  static get loginContinue => "loginContinue".tr;
}
